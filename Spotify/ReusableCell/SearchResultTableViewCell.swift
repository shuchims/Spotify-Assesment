//
//  Untitled.swift
//  Spotify
//
//  Created by Shuchi Mehra Sharma on 07/12/24.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    var isComeFromPlaylistDetails : Bool = false
    
    @IBOutlet weak var moreOption: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        artworkImageView.layer.cornerRadius = 20
        artworkImageView.clipsToBounds = true
        artworkImageView.contentMode = .scaleAspectFill
        
    }
    
    func configure(with song: Song) {
        backgroundColor = .clear // Transparent for gradient
        if(isComeFromPlaylistDetails){
            artworkImageView.layer.cornerRadius = 0
            moreOption.isHidden = false
        }
        songTitleLabel.text = song.title
        artistNameLabel.text = song.artist
        if let artworkURL = song.artworkURL, let url = URL(string: artworkURL) {
            // Load image asynchronously (use libraries like SDWebImage for better caching)
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.artworkImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        } else {
            artworkImageView.image = UIImage(systemName: "music.note") // Default image
        }
    }
}
