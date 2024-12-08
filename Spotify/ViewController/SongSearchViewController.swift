//
//  SongSearchViewController.swift
//  Spotify
//
//  Created by Shuchi Mehra Sharma on 07/12/24.
//

import UIKit

class SongSearchViewController: UIViewController {
    private var songs: [Song] = []
    var playlist: Playlist?
    @IBOutlet weak var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    private var debounceTimer: Timer?
    var didSelectSong: ((Song) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupRefreshControl()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        tableView.addGestureRecognizer(tapGesture)
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.hidesSearchBarWhenScrolling = false
        // Customize the search bar
        customizeSearchBarAppearance()
    }
    
    private func customizeSearchBarAppearance() {
        searchController.searchBar.tintColor = .white
        // Customize placeholder text color
        if let searchTextField = searchController.searchBar.searchTextField as? UITextField {
            searchTextField.attributedPlaceholder = NSAttributedString(
                string: "Search",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
        }
    }
    
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshSongs), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    @objc private func refreshSongs() {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            tableView.refreshControl?.endRefreshing()
            return
        }
        fetchSongs(for: query)
        tableView.refreshControl?.endRefreshing()
    }
    
    private func fetchSongs(for query: String) {
        iTunesAPIManager.shared.searchSongs(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let songs):
                    self?.songs = songs
                    DispatchQueue.main.async {
                        UIView.performWithoutAnimation {
                            self?.tableView.reloadData()
                            self?.showEmptyStateIfNeeded()
                        }
                    }
                    
                case .failure(let error):
                    print("Error fetching songs: \(error)")
                }
            }
        }
    }
    
    private func showEmptyStateIfNeeded() {
        if songs.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "No results found"
            emptyLabel.textAlignment = .center
            emptyLabel.textColor = .lightGray
            emptyLabel.font = UIFont.systemFont(ofSize: 16)
            tableView.backgroundView = emptyLabel
        } else {
            tableView.backgroundView = nil
        }
    }
    
}

extension SongSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count // Replace with your data source
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        let song = songs[indexPath.row]
        cell.configure(with: song)
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let selectedSong = songs[indexPath.row]
        //        didSelectSong?(selectedSong)
        //        navigationController?.popViewController(animated: true)
        
        guard let playlistName = playlist?.name else { return }
        let selectedSong = songs[indexPath.row]
        // Save the song to the selected playlist
        PersistenceManager.shared.addSong(selectedSong, to: playlistName)
        navigationController?.popViewController(animated: true)
        
    }
}

extension SongSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let query = searchBar.text, !query.isEmpty else { return }
            self?.fetchSongs(for: query)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        debounceTimer?.invalidate()
        guard let query = searchBar.text, !query.isEmpty else { return }
        fetchSongs(for: query)
    }
    
    
}
extension SongSearchViewController: UIGestureRecognizerDelegate {
    
    @objc private func dismissKeyboard() {
        searchController.searchBar.resignFirstResponder()
    }
}
