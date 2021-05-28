//
//  TrackDetailView.swift
//  BestMusic
//
//  Created by Игорь Никифоров on 26.05.2021.
//

import UIKit
import SDWebImage
import AVKit

class TrackDetailView: UIView {

    // MARK: Outlets

    @IBOutlet private weak var trackImageView: UIImageView!
    @IBOutlet private weak var currentTimeSlider: UISlider!
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var durationTimeLabel: UILabel!
    @IBOutlet private weak var trackTitleLabel: UILabel!
    @IBOutlet private weak var authorTitleLabel: UILabel!
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var volumeSlider: UISlider!

    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        trackImageView.backgroundColor = .green
    }

}

// MARK: Public methods

extension TrackDetailView {

    func set(viewModel: SearchViewModel.Cell) {
        trackTitleLabel.text = viewModel.trackName
        authorTitleLabel.text = viewModel.artistName

        playTrack(previewUrl: viewModel.previewUrl)

        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
    }

}

// MARK: Private methods

private extension TrackDetailView {

    @IBAction func drugDownButtonTapped(_ sender: UIButton) {
        removeFromSuperview()
    }

    @IBAction func currentTimeSliderValueChanged(_ sender: UISlider) {
    }


    @IBAction func volumeSliderValueChanged(_ sender: UISlider) {
    }

    @IBAction func previousTrackButtonTapped(_ sender: UIButton) {
    }

    @IBAction func nextTrackButtonTapped(_ sender: UIButton) {
    }


    @IBAction func playPauseButtonTapped(_ sender: Any) {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(UIImage(named: "TrackDetai/pause"), for: .normal)
        } else {
            player.pause()
            playPauseButton.setImage(UIImage(named: "TrackDetai/play"), for: .normal)
        }
    }
    
    func playTrack(previewUrl: String?) {
        guard let url = URL(string: previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }

}
