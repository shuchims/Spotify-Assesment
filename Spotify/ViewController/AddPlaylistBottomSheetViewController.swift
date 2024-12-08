//
//  Untitled.swift
//  Spotify
//
//  Created by Shuchi Mehra Sharma on 07/12/24.
//

import UIKit
import PanModal

protocol AddPlaylistBottomSheetDelegate: AnyObject {
    func didTapCreatePlaylist()
}


class AddPlaylistBottomSheetViewController: UIViewController,PanModalPresentable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    weak var delegate: AddPlaylistBottomSheetDelegate?
    var completionHandler: (() -> Void)?
    var panScrollable: UIScrollView? { nil }
    var shortFormHeight: PanModalHeight { .contentHeight(100) }
    var longFormHeight: PanModalHeight { .contentHeight(100) }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // Customize the labels and icon if needed
        titleLabel.text = "Playlist"
        subtitleLabel.text = "Create a playlist with a song"
    }
    
    @IBAction func createPlaylistTapped(_ sender: UIButton) {
        dismiss(animated: true) {
            self.completionHandler?()
        }
    }
    
}

