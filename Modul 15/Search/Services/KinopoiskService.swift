//
//  KinopoiskSearch.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 29.08.2023.
//

import UIKit

// MARK: - KinopoiskSearchService

final class KinopoiskSearchService: SearchServiceProtocol {

    // MARK: - Properties

    @Injected private var networkService: NetworkService!

    // MARK: - Methods

    func handleRequest(searchText: String, completion: (([MovieDisplayModel], String?) -> Void)?) {
        kinoPoiskSearch(searchText: searchText, completion: completion)
    }

    func getImage(urlString: String?, completion: ((Data?) -> Void)?) {
        guard let urlString = urlString else {
            completion?(nil)
            return
        }

        networkService.loadData(urlString: urlString) { image in
            completion?(image)
        }
    }
}

// MARK: - Private Methods

fileprivate extension KinopoiskSearchService {
    func kinoPoiskSearch(searchText: String, completion: (([MovieDisplayModel], String?) -> Void)?) {
        var params = KinoPoiskSearchParams()
        params.parameters?.updateValue(searchText, forKey: "query")
        networkService.getSearchResults(KinoPoiskResponse.self, searchParams: params) { result, error in

            if let error = error {
                completion?([], error.localizedDescription)
                return
            }

            guard let result = result else {
                completion?([], "No results")
                return
            }

            var movies = [MovieDisplayModel]()

            result.docs.forEach {
                let shortDescription = ($0.shortDescription ?? "").isEmpty
                ? "Tap to see more details..."
                : $0.shortDescription

                movies.append(MovieDisplayModel(
                    id: "\($0.id)",
                    imageURL: $0.poster,
                    title: $0.name,
                    description: shortDescription ?? "",
                    fullDescription: $0.description
                ))
            }
            completion?(movies, nil)
        }
    }
}
