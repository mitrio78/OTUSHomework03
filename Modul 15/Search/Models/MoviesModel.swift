//
//  MoviesModel.swift
//
//  Created by Dmitriy Grishechko on 14.05.2023.
//

import UIKit

enum SearchServiceType {
    case kinopoisk
    case omdb
}

struct MovieDisplayModel {
    var id: String
    var image: UIImage?
    var imageURL: String?
    var title: String
    var description: String
    var fullDescription: String?
}
