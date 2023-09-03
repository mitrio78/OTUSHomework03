//
//  FavouritesService.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 03.09.2023.
//

import Foundation

protocol FavoritesServiceProtocol {
    func save(_ movie: MovieDisplayModel)
    func loadFavorites() -> [MovieDisplayModel]
}

final class FavoritesService: FavoritesServiceProtocol {

    private init() { }

    static let shared: FavoritesServiceProtocol = FavoritesService()

    private var storage: StorageServiceProtocol = StorageService.shared

    func save(_ movie: MovieDisplayModel) {
        var movies = loadFavorites()
        movies.append(movie)
        storage.save(movies)
    }

    func loadFavorites() -> [MovieDisplayModel] {
        guard let movies = storage.load(of: [MovieDisplayModel].self) else {
            return []
        }
        return movies
    }
}
