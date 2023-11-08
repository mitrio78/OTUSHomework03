//
//  Configurator.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 05.09.2023.
//

import CoreServicesTest
import Foundation

final class Configurator {

    static var shared: Configurator = .init()

    private init() { }

    func register() {
        ServiceLocator.shared.add(object: NetworkService())
        ServiceLocator.shared.add(object: StorageService())
        ServiceLocator.shared.add(object: KinopoiskSearchService())
        ServiceLocator.shared.add(object: OMDBSearchService())
        ServiceLocator.shared.add(object: FavoritesService())
        ServiceLocator.shared.add(object: SearchInteractor())
    }
}
