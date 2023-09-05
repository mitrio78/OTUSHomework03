//
//  ServiceLocator.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 05.09.2023.
//

import Foundation

final class ServiceLocator {

    static let shared: ServiceLocator = ServiceLocator()

    private init() { }

    private var services: [String: Any] = [:]

    func add<T: AnyObject>(object: T) {
        let key = String(describing: T.self)
        services[key] = object
    }

    func get<T: AnyObject>() -> T? {
        let key = String(describing: T.self)
        return services[key] as? T
    }
}
