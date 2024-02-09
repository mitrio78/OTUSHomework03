//
//  ServiceLocator.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 05.09.2023.
//

import Foundation

final class ServiceLocator {

    static let shared = ServiceLocator()

    private init() { }

    private var dependencies = [String: Any]()

    func register<T>(type: T.Type, object: T) {
        let key = "\(type)"
        dependencies[key] = object
    }

    func resolve<T>(_ type: T.Type) -> T? {
        let key = "\(type)"
        return dependencies[key] as? T
    }
}
