//
//  MoviesModel.swift
//
//  Created by Dmitriy Grishechko on 14.05.2023.
//

import Foundation

enum SearchServiceType {
    case kinopoisk
    case omdb
}

struct MovieDisplayModel: Codable {
    var id: String
    var image: Data?
    var imageURL: String?
    var title: String
    var description: String
    var fullDescription: String?
}

struct MovieGridModel: Codable, Identifiable {
    var id: String = ""
    var image: String = ""
    var title: String = ""
    var description: String = ""
    var fullDescription: String = ""
}
