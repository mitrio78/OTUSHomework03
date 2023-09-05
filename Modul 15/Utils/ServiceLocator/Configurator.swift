//
//  Configurator.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 05.09.2023.
//

import Foundation

final class Configurator {

    static var shared: Configurator = .init()

    private init() { }

    func register() {
        ServiceLocator.shared.add(object: NetworkService())
        ServiceLocator.shared.add(object: StorageService())
    }
}
