//
//  Untitled.swift
//  Spotify
//
//  Created by Shuchi Mehra Sharma on 07/12/24.
//

import UIKit
import PanModal

protocol AddPlaylistDelegate: AnyObject {
    func didAddPlaylist(_ playlist: Playlist)
}
class AddPlaylistViewController: UIViewController, UITextViewDelegate {
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    weak var delegate: AddPlaylistDelegate? // Delegate property
    var onSave: ((Playlist) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.nameTextField.becomeFirstResponder()
    }
    
    private func setupUI() {
        saveButton.setTitle("Confirm", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.layer.cornerRadius = 25
    }
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(title: "Error", message: "Please enter a playlist name.")
            return
        }
        
        let playlist = Playlist(id: UUID(), name: name, songs: []) // Create playlist
        dismiss(animated: true) {
            PersistenceManager.shared.savePlaylist(playlist)
            self.onSave?(playlist) // Notify the completion handler
        }
        
        
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
extension AddPlaylistViewController: PanModalPresentable {
    var panScrollable: UIScrollView? { return nil }
    
}
