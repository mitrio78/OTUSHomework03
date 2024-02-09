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
        ServiceLocator.shared.register(type: NetworkServiceProtocol.self, object: NetworkService())
        ServiceLocator.shared.register(type: StorageServiceProtocol.self, object: StorageService())
        ServiceLocator.shared.register(type: SearchAPIServiceProtocol.self, object: SearchAPIService())
        ServiceLocator.shared.register(type: FavoritesServiceProtocol.self, object: FavoritesService())
        ServiceLocator.shared.register(type: SearchViewModelProtocol.self, object: SearchViewModel())
    }
}
