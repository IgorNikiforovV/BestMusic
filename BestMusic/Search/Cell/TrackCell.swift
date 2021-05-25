//
//  TrackCell.swift
//  BestMusic
//
//  Created by Игорь Никифоров on 23.05.2021.
//

import UIKit
import SDWebImage

protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionName: String { get }
}

class TrackCell: UITableViewCell {

    // MARKL: IBOutlets

    @IBOutlet private weak var trackImageView: UIImageView!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var collectionNameLabel: UILabel!
    
    // MARKL: Properties

    static let reuseId = "TrackCell"

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        trackImageView.image = nil
    }

}

// MARKL: - Public methods

extension TrackCell {

    func set(_ viewModel: TrackCellViewModel) {
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName

        if let iconUrl = URL(string: viewModel.iconUrlString ?? "") {
            trackImageView.sd_setImage(with: iconUrl, completed: nil)
        }
    }

}
