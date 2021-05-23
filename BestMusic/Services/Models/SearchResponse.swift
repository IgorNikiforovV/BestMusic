//
//  SearchResponse.swift
//  BestMusic
//
//  Created by Игорь Никифоров on 18.05.2021.
//

struct SearchResponse: Decodable {
    let resultCount: Int
    let results: [Track]
}

struct Track: Decodable {
    let trackName: String?
    let collectionName: String?
    let artistName: String?
    let artworkUrl100: String?
    let previewUrl: String?
}
