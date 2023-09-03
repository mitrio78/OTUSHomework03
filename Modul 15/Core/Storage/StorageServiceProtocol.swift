//
//  StorageServiceProtocol.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 03.09.2023.
//

import Foundation

public protocol StorageServiceProtocol {
    func save<T: Codable>(_ incomingData: T)
    func load<T: Decodable>(of type: T.Type) -> T?
}
