//
//  Untitled.swift
//  Spotify
//
//  Created by Shuchi Mehra Sharma on 07/12/24.
//

import Foundation

class iTunesAPIManager {
    static let shared = iTunesAPIManager()
    private init() {}

    func searchSongs(query: String, completion: @escaping (Result<[Song], Error>) -> Void) {
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(query)&entity=musicTrack&limit=25")
        else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }

            do {
                let result = try JSONDecoder().decode(iTunesResponse.self, from: data)
                let songs = result.results.map { track in
                    Song(
                        id: String(track.trackId),
                        title: track.trackName,
                        artist: track.artistName,
                        artworkURL: track.artworkUrl100
                    )
                }
                completion(.success(songs))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

struct iTunesResponse: Codable {
    let results: [iTunesTrack]
}

struct iTunesTrack: Codable {
    let trackId: Int
    let trackName: String
    let artistName: String
    let artworkUrl100: String?
}
