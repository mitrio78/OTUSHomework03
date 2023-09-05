//
//  FavouritesService.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 03.09.2023.
//

import Foundation

// MARK: - FavoritesServiceProtocol

protocol FavoritesServiceProtocol {
    func save(_ movie: MovieDisplayModel)
    func loadFavorites() -> [MovieDisplayModel]
}

// MARK: - FavoritesService

final class FavoritesService: FavoritesServiceProtocol {

    // MARK: - Properties

    @Injected private var storage: StorageService!

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
