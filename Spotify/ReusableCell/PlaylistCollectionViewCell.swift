//
//  PlaylistCollectionViewCell.swift
//  Spotify
//
//  Created by Shuchi Mehra Sharma on 07/12/24.
//

import UIKit

class PlaylistCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var songLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       // setupUI()
       // print("titleLabel: \(titleLabel)") // Should not be nil
    }

    func configure(with playlist: Playlist) {
        titleLabel.text = playlist.name
        imageView.image = UIImage(named: "firstLibrary") // Placeholder image
        songLabel.text =  "Playlist " + "\(playlist.songs.count) songs"
    }
}

