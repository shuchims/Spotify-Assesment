//
//  Untitled.swift
//  Spotify
//
//  Created by Shuchi Mehra Sharma on 08/12/24.
//
import UIKit

import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()
    private let playlistsKey = "playlists"
    
    private init() {}

    // Save a playlist
    func savePlaylist(_ playlist: Playlist) {
        var playlists = loadPlaylists()
        playlists.append(playlist)
        savePlaylists(playlists)
    }

    // Load all playlists
    func loadPlaylists() -> [Playlist] {
        guard let data = UserDefaults.standard.data(forKey: playlistsKey),
              let playlists = try? JSONDecoder().decode([Playlist].self, from: data) else {
            return []
        }
        return playlists
    }

    // Update playlists (for adding songs to a specific playlist)
    private func savePlaylists(_ playlists: [Playlist]) {
        if let data = try? JSONEncoder().encode(playlists) {
            UserDefaults.standard.set(data, forKey: playlistsKey)
        }
    }

    // Add a song to a specific playlist
    func addSong(_ song: Song, to playlistName: String) {
        var playlists = loadPlaylists()
        if let index = playlists.firstIndex(where: { $0.name == playlistName }) {
            playlists[index].songs.append(song)
            savePlaylists(playlists)
        }
    }

    // Fetch songs for a specific playlist
    func fetchSongs(for playlistName: String) -> [Song] {
        let playlists = loadPlaylists()
        return playlists.first(where: { $0.name == playlistName })?.songs ?? []
    }
}

