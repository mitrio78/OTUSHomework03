//
//  SearchService.swift
//
//  Created by Dmitriy Grishechko on 14.05.2023.
//

import UIKit

// MARK: - SearchService

final class OMDBSearchService: SearchServiceProtocol {

    // MARK: - Private properties

    var networkService: NetworkServiceProtocol {
        NetworkService.shared
    }
    
    // MARK: - Methods

    func handleRequest(searchText: String, completion: (([MovieDisplayModel], String?) -> Void)?) {
        omdbSearch(searchText: searchText) { movies, error in
            completion?(movies, error)
        }
    }
}

// MARK: - Private Methods

fileprivate extension OMDBSearchService {

    func omdbSearch(searchText: String, completion: (([MovieDisplayModel], String?) -> Void)?) {
        var params = OMDBSearchParams()
        params.parameters?.updateValue(searchText, forKey: "s")
        networkService.getSearchResults(OMDBResponse.self, searchParams: params) { result, error in

            if let error = error {
                completion?([], error.localizedDescription)
                return
            }

            guard let result = result else {
                completion?([], "No results")
                return
            }

            var movies = [MovieDisplayModel]()

            result.results.forEach {
                movies.append(MovieDisplayModel(
                    id: $0.imdbID ?? "",
                    imageURL: $0.imageUrl,
                    title: $0.title ?? "",
                    description: $0.title ?? ""
                ))
            }
            completion?(movies, nil)
        }
    }
}
