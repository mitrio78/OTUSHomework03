//
//  StorageService.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 03.09.2023.
//

import Foundation

public final class StorageService: StorageServiceProtocol {

    public static var shared: StorageServiceProtocol = StorageService()

    private var userDefaults = UserDefaults.standard

    private init() { }

    public func save<T: Codable>(_ incomingData: T) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(incomingData)
            userDefaults.setValue(data, forKey: StorageKeys.favorites.rawValue)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    public func load<T: Decodable>(of type: T.Type) -> T? {
        var result: T?
        do {
            let decoder = JSONDecoder()
            guard let data = userDefaults.data(forKey: StorageKeys.favorites.rawValue) else {
                return nil
            }

            result = try decoder.decode(T.self, from: data)
        } catch {
            debugPrint(error.localizedDescription)
        }

        return result
    }
}
