//
//  Untitled.swift
//  Spotify
//
//  Created by Shuchi Mehra Sharma on 08/12/24.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var songCountLabel: UILabel!
    
    // MARK: - Configure Cell
    func configure(with playlist: Playlist) {
        
        // Set thumbnail image (use placeholder if needed)
        thumbnailImageView.image = UIImage(named: "firstLibrary") // Replace with actual image logic
        
        // Set playlist title
        titleLabel.text = playlist.name
        
        // Set song count
        songCountLabel.text = "\(playlist.songs.count) songs"
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}
