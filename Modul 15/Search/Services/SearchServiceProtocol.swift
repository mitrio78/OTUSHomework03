//
//  SearchServiceProtocol.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 29.08.2023.
//

import UIKit

// MARK: - SearchServiceProtocol

protocol SearchServiceProtocol {
    func handleRequest(searchText: String, completion: (([MovieDisplayModel], String?) -> Void)?)
    func getImage(urlString: String?, completion: ((Data?) -> Void)?)
}
