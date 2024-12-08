//
//  Untitled.swift
//  Spotify
//
//  Created by Shuchi Mehra Sharma on 08/12/24.
//

import UIKit
import PanModal
class PlaylistDetailsViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var songsCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var playlist: Playlist? // Pass the playlist data here
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarButtons()
        setupGradientBackground()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        loadSongs()
    }
    
    private func setupGradientBackground() {
        // Define the gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 32/255, green: 22/255, blue: 60/255, alpha: 1).cgColor, // Dark purple/blue
            UIColor.black.cgColor // Black
        ]
        gradientLayer.locations = [0.0, 0.6] // 60% purple, rest black
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0) // Top-center
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1) // Bottom-center
        gradientLayer.frame = view.bounds
        
        // Add the gradient layer to the view
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }
    
    private func setupUI() {
        guard let playlist = playlist else { return }
        titleLabel.text = playlist.name
        songsCountLabel.text = "\(PersistenceManager.shared.fetchSongs(for: playlist.name).count) songs"
        tableView.reloadData()
    }
    private func setupNavigationBarButtons() {
        // Create a custom left button
        let leftButton = UIButton(type: .system)
        leftButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal) // Example: Back icon
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        leftButton.tintColor = .white
        let leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        // Create a custom right button
        let rightButton = UIButton(type: .system)
        rightButton.setImage(UIImage(systemName: "plus"), for: .normal) // Example: Options icon
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        rightButton.tintColor = .white
        let rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        // Assign to navigation bar
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        // Make the navigation bar transparent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    @objc private func leftButtonTapped() {
        // Handle left button tap
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func rightButtonTapped() {
        openSongSearchViewController()
        
    }
    private func openSongSearchViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let songSearchVC = storyboard.instantiateViewController(withIdentifier: "SongSearchViewController") as? SongSearchViewController {
            songSearchVC.playlist = playlist
            navigationController?.pushViewController(songSearchVC, animated: true)
        }
    }
    private func loadSongs() {
        guard let playlistName = playlist?.name else { return }
        playlist?.songs = PersistenceManager.shared.fetchSongs(for: playlistName)
        tableView.reloadData()
    }
}

extension PlaylistDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist?.songs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        guard let song = playlist?.songs[indexPath.row] else { return  UITableViewCell()}
        cell.isComeFromPlaylistDetails = true
        cell.configure(with: song)
        
        return cell
    }
    
    
}

extension PlaylistDetailsViewController: PanModalPresentable {
    var panScrollable: UIScrollView? { return nil }
    var shortFormHeight: PanModalHeight { return .contentHeight(112) }
    var longFormHeight: PanModalHeight { return .contentHeight(112) }
    var cornerRadius: CGFloat { return 16.0 }
    var shouldRoundTopCorners: Bool { return true }
}

