//
//  OMDBResponse.swift
//
//  Created by Dmitriy Grishechko on 05.04.2023.
//

import Foundation

struct OMDBResponse: Decodable {
    let results: [MovieModel]

    enum CodingKeys: String, CodingKey {
        case results = "Search"
    }
}

struct MovieModel: Decodable {
    let title: String?
    let year: String?
    let imdbID: String?
    let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case imageUrl = "Poster"
    }
}
