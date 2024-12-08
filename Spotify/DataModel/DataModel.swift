//
//  DataModel.swift
//  Spotify
//
//  Created by Shuchi Mehra Sharma on 07/12/24.
//

import Foundation

struct Playlist: Codable {
    let id: UUID
    let name: String
    var songs: [Song]
}

struct Song: Codable {
    let id: String
    let title: String
    let artist: String
    let artworkURL: String?
}

