//
//  DI.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 05.09.2023.
//

import Foundation

class DI {

    static let shared = DI()

    private init() { }
    
    lazy var kinopoiskSearch: SearchServiceProtocol = {
        KinopoiskSearchService()
    }()

    lazy var omdbSearch: SearchServiceProtocol = {
        OMDBSearchService()
    }()

    lazy var favouritesService: FavoritesServiceProtocol = {
        FavoritesService()
    }()
}
