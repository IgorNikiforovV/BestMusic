//
//  TrackDetailView.swift
//  BestMusic
//
//  Created by Игорь Никифоров on 26.05.2021.
//

import UIKit
import SDWebImage
import AVKit

protocol TrackMovingDelegate: AnyObject {
    func moveBackForPreviousTrack() -> SearchViewModel.Cell?
    func moveForwardForPreviousTrack() -> SearchViewModel.Cell?
}

class TrackDetailView: UIView {

    // MARK: Outlets

    @IBOutlet private weak var miniTrackView: UIView!
    @IBOutlet private weak var miniTrackImageView: UIImageView!
    @IBOutlet private weak var miniTrackTitleLabel: UILabel!
    @IBOutlet private weak var miniPlayPauseButton: UIButton!
    @IBOutlet private weak var miniGoForwardButton: UIButton!

    @IBOutlet private weak var maximizedStackView: UIStackView!
    @IBOutlet private weak var trackImageView: UIImageView!
    @IBOutlet private weak var currentTimeSlider: UISlider!
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var durationTimeLabel: UILabel!
    @IBOutlet private weak var trackTitleLabel: UILabel!
    @IBOutlet private weak var authorTitleLabel: UILabel!
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var volumeSlider: UISlider!

    weak var delegate: TrackMovingDelegate?
    weak var tabBarDelegate: MainTabBarControllerDelegate?

    private let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        configureTrackImageView()
        configureMiniPlayPauseButton()
        setupGesture()
    }

}

// MARK: Public methods

extension TrackDetailView {

    func set(viewModel: SearchViewModel.Cell) {
        trackTitleLabel.text = viewModel.trackName
        authorTitleLabel.text = viewModel.artistName
        miniTrackTitleLabel.text = viewModel.trackName

        playTrack(previewUrl: viewModel.previewUrl)
        observePlayerCurrentTime()
        playPauseButton.setImage(UIImage(named: "TrackDetai/pause"), for: .normal)
        miniPlayPauseButton.setImage(UIImage(named: "TrackDetai/pause"), for: .normal)
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        miniTrackImageView.sd_setImage(with: url, completed: nil)
        trackImageView.sd_setImage(with: url, completed: nil)

        monitorStartTime()
    }

    func setMiniTrackView(_ alpha: CGFloat) {
        miniTrackView.alpha = alpha
    }

    func setMaximizedStackView(_ alpha: CGFloat) {
        maximizedStackView.alpha = alpha
    }

}

// MARK: Private methods

private extension TrackDetailView {

    // MARK: - Configure

    func configureTrackImageView() {
        trackImageView.layer.cornerRadius = 5
        setTrackImageView()
    }

    func configureMiniPlayPauseButton() {
        miniPlayPauseButton.imageEdgeInsets = .init(top: 11, left: 11, bottom: 11, right: 11)
    }

    // MARK: - Setup

    func setTrackImageView() {
        let scale: CGFloat = 0.8
        trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }

    func setupGesture() {
        miniTrackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximized)))
        miniTrackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
    }

    // MARK: - maximized and minimized gesture

    @objc func handleTapMaximized() {
        print("Tapping to maximized")
        self.tabBarDelegate?.maximizedTrackDetailController(viewModel: nil)
    }

    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            print("began")
        case .changed:
            handlePanChanged(gesture: gesture)
        case .ended:
            handlePanEnded(gesture: gesture)
        default:
            break
        }
    }

    func handlePanChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)

        let newAlpha = 1 + translation.y / 200
        self.miniTrackView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.maximizedStackView.alpha = -translation.y / 200
    }

    func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.transform = .identity
                        if translation.y < -200 || velocity.y < -500 {
                            self.tabBarDelegate?.maximizedTrackDetailController(viewModel: nil)
                        } else {
                            self.miniTrackView.alpha = 1
                            self.maximizedStackView.alpha = 0
                        }
                       },
                       completion: nil)
    }

    @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
            case .changed:
                let translation = gesture.translation(in: self.superview)
                maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            case .ended:
                let transletion = gesture.translation(in: self.superview)
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 1,
                               options: .curveEaseOut,
                               animations: {
                                self.maximizedStackView.transform = .identity
                                if transletion.y > 50 {
                                    self.tabBarDelegate?.minimizedTrackDetailController()
                                }
                               },
                               completion: nil)
            default:
                break
        }
    }

    // MARK: - @IBAction

    @IBAction func drugDownButtonTapped(_ sender: UIButton) {
        tabBarDelegate?.minimizedTrackDetailController()
    }

    @IBAction func currentTimeSliderValueChanged(_ sender: UISlider) {
        guard let duration = player.currentItem?.duration else { return }
        let percentage = currentTimeSlider.value
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)

        player.seek(to: seekTime)
    }


    @IBAction func volumeSliderValueChanged(_ sender: UISlider) {
        player.volume = volumeSlider.value
    }

    @IBAction func previousTrackButtonTapped(_ sender: UIButton) {
        if let cellViewModel = delegate?.moveBackForPreviousTrack() {
            set(viewModel: cellViewModel)
        }
    }

    @IBAction func nextTrackButtonTapped(_ sender: UIButton) {
        if let cellViewModel = delegate?.moveForwardForPreviousTrack() {
            set(viewModel: cellViewModel)
        }
    }


    @IBAction func playPauseButtonTapped(_ sender: Any) {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(UIImage(named: "TrackDetai/pause"), for: .normal)
            miniPlayPauseButton.setImage(UIImage(named: "TrackDetai/pause"), for: .normal)
            enlageTrackImageView()
        } else {
            player.pause()
            playPauseButton.setImage(UIImage(named: "TrackDetai/play"), for: .normal)
            miniPlayPauseButton.setImage(UIImage(named: "TrackDetai/play"), for: .normal)
            reduceTrackImageView()
        }
    }
    
    func playTrack(previewUrl: String?) {
        guard let url = URL(string: previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }

    // MARK: - Time setup

    func monitorStartTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlageTrackImageView()
        }
    }

    func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTimeLabel.text = time.toDisplayString()
            let durationTime = self?.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1)
            let currentDurationText = (durationTime - time).toDisplayString()
            self?.durationTimeLabel.text = "-\(currentDurationText)"

            self?.updateCurrentTimeSlider()
        }
    }

    func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))

        let percentage = currentTimeSeconds / durationSeconds
        currentTimeSlider.value = Float(percentage)
    }

    // MARK: - Animations

    func enlageTrackImageView() {
        strtAnimation {
            self.trackImageView.transform = .identity
        }
    }

    func reduceTrackImageView() {
        strtAnimation {
            self.setTrackImageView()
        }
    }

    func strtAnimation(animations: @escaping () -> Void) {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: animations,
                       completion: nil)
    }

}
