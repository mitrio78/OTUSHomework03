//
//  Injected.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 05.09.2023.
//

import Foundation

@propertyWrapper
struct Injected<T: AnyObject> {

    private var service: T?

    var serviceLocator = ServiceLocator.shared

    var wrappedValue: T? {
        mutating get {
            self.service = self.serviceLocator.get()
            return service
        }
        mutating set {
            service = newValue
        }
    }

    var projectedValue: Injected<T> {
        mutating get {
            return self
        }
        mutating set {
            self = newValue
        }
    }
}
