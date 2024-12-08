//
//  LibraryViewController.swift
//  Spotify
//
//  Created by Shuchi Mehra Sharma on 07/12/24.
//

import UIKit

class LibraryViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addPlaylistButton: UIButton!
    @IBOutlet weak var switchViewButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var playlistsButton: UIButton!
    
    private var isGridView = true
    private var playlists: [Playlist] = [] // Data source
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        stylePlaylistsButton()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.reloadData()
    }
    
    private func setupUI() {
        
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        collectionView.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListCollectionViewCell")
        collectionView.collectionViewLayout = createGridLayout()
    }
    private func stylePlaylistsButton() {
        playlistsButton.setTitleColor(.label, for: .normal) // Dynamic text color
        playlistsButton.backgroundColor = .clear           // Clear background
        playlistsButton.layer.borderColor = UIColor.gray.cgColor // Gray border
        playlistsButton.layer.borderWidth = 1.0            // Border width
        playlistsButton.layer.cornerRadius = 16             // Rounded corners
        playlistsButton.isUserInteractionEnabled = false   // Disable interaction
    }
    
    @IBAction func addPlaylistTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let bottomSheetVC = storyboard.instantiateViewController(withIdentifier: "AddPlaylistBottomSheetViewController") as? AddPlaylistBottomSheetViewController {
            bottomSheetVC.completionHandler = { [weak self] in
                self?.openAddPlaylistViewController()
            }
            presentPanModal(bottomSheetVC)
        }
    }
    
    func openAddPlaylistViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addPlaylistVC = storyboard.instantiateViewController(withIdentifier: "AddPlaylistViewController") as? AddPlaylistViewController {
            // Set up the completion handler for AddPlaylistViewController
            addPlaylistVC.onSave = { [weak self] playlist in
                self?.openPlaylistDetails(for: playlist)
            }
            present(addPlaylistVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func switchViewTapped(_ sender: UIButton) {
        isGridView.toggle()
        switchViewButton.setImage(UIImage(systemName: isGridView ? "square.grid.2x2.fill" : "list.bullet"), for: .normal)
        collectionView.collectionViewLayout = isGridView ? createGridLayout() : createListLayout()
        collectionView.reloadData()
    }
    // Navigate to PlaylistDetailsViewController
    private func openPlaylistDetails(for playlist: Playlist) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "PlaylistDetailsViewController") as? PlaylistDetailsViewController {
            detailsVC.playlist = playlist // Pass the playlist name
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    private func showAddPlaylistAlert() {
        let alert = UIAlertController(title: "Add Playlist", message: "Enter playlist name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Playlist Name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            guard let name = alert.textFields?.first?.text, !name.isEmpty else { return }
            let newPlaylist = Playlist(id: UUID(), name: name, songs: [])
            PersistenceManager.shared.savePlaylist(newPlaylist)
            self?.collectionView.reloadData()
        }))
        present(alert, animated: true)
    }
    
    private func createGridLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 170, height: 226)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    private func createListLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 32, height: 84)
        layout.minimumLineSpacing = 8
        return layout
    }
    
    
    
}
extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PersistenceManager.shared.loadPlaylists().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let playlist = PersistenceManager.shared.loadPlaylists()[indexPath.row]
        
        let currentLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        if let layout = currentLayout, layout.itemSize.width == 170 {
            // Grid layout
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaylistCell", for: indexPath) as! PlaylistCollectionViewCell
            cell.configure(with: playlist)
            return cell
        } else {
            // List layout
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell", for: indexPath) as! ListCollectionViewCell
            cell.configure(with: playlist)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPlaylist = PersistenceManager.shared.loadPlaylists()[indexPath.row]
        openPlaylistDetails(for: selectedPlaylist)
    }
    
}


extension LibraryViewController: AddPlaylistDelegate {
    func didAddPlaylist(_ playlist: Playlist) {
        // Save the playlist to the ViewModel
        PersistenceManager.shared.savePlaylist(playlist)
        collectionView.reloadData()
    }
}

extension LibraryViewController: AddPlaylistBottomSheetDelegate {
    func didTapCreatePlaylist() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addPlaylistVC = storyboard.instantiateViewController(withIdentifier: "AddPlaylistViewController") as? AddPlaylistViewController {
            addPlaylistVC.modalPresentationStyle = .fullScreen
            present(addPlaylistVC, animated: true, completion: nil)
        }
    }
}
extension UIViewController {
    func dismissPresentedIfNeeded(completion: @escaping () -> Void) {
        if let presentedVC = presentedViewController {
            presentedVC.dismiss(animated: true, completion: completion)
        } else {
            completion()
        }
    }
}


