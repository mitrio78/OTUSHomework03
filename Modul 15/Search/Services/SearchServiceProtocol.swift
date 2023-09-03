//
//  SearchServiceProtocol.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 29.08.2023.
//

import UIKit

// MARK: - SearchServiceProtocol

protocol SearchServiceProtocol {
    var networkService: NetworkServiceProtocol { get }
    func handleRequest(searchText: String, completion: (([MovieDisplayModel], String?) -> Void)?)
    func getImage(urlString: String?, completion: ((Data?) -> Void)?)
}

extension SearchServiceProtocol {

    func getImage(urlString: String?, completion: ((Data?) -> Void)?) {
        guard let urlString = urlString else {
            completion?(nil)
            return
        }

        networkService.loadImage(urlString: urlString) { image in
            completion?(image)
        }
    }
}
