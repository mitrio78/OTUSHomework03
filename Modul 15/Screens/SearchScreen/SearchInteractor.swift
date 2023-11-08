//
//  SearchInteractor.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 08.11.2023.
//

import Combine
import Foundation

// MARK: - SearchInteractor

final class SearchInteractor: ObservableObject {

    // MARK: - Dependencies

    @Injected private var kinopoiskService: KinopoiskSearchService!
    @Injected private var omdbService: OMDBSearchService!
    @Injected private var storage: FavoritesService!

    // MARK: - Properties

    @Published private(set) var movies: [MovieDisplayModel] = []
    @Published private(set) var searchType: SearchServiceType = .omdb
    @Published private(set) var isLoading: Bool = false

    private var timer: Timer?

    private var currentSearchService: SearchServiceProtocol {
        switch searchType {
        case .kinopoisk:
            return kinopoiskService

        case .omdb:
            return omdbService
        }
    }

    // MARK: - Methods

    func toggleSearchService() {
        movies = []
        switch searchType {
        case .omdb:
            searchType = .kinopoisk

        case .kinopoisk:
            searchType = .omdb
        }
    }

    func addToFavorites(_ index: Int) {
        storage.save(movies[index])
    }

    func searchMovie(_ searchText: String) {
        guard !searchText.isEmpty, searchText.count > 2 else {
            return
        }

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
            self.isLoading = true
            self.fetchData(searchText: searchText)
        }
    }
}

// MARK: - MovieCellDelegate

extension SearchInteractor: MovieCellDelegate {
    func uploadImages(for id: String, image urlString: String, completion: ((Data?) -> Void)?) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let cacheImage = self?.movies.first(where: { $0.id == id })?.image else {
                self?.currentSearchService.getImage(urlString: urlString) { image in
                    if let movieIndex = self?.movies.firstIndex(where: { $0.id == id }) {
                        self?.movies[movieIndex].image = image
                    }

                    DispatchQueue.main.async {
                        completion?(image)
                    }
                }
                return
            }
            DispatchQueue.main.async {
                completion?(cacheImage)
            }
        }
    }
}

// MARK: - Private Methods

fileprivate extension SearchInteractor {

    func resetData() {
        movies = []
    }

    func fetchData(searchText: String) {
        currentSearchService.handleRequest(searchText: searchText) { [weak self] searchResult, errorMessage in
            if let _ = errorMessage {
                self?.resetData()
                // TODO: Error
                self?.isLoading = false
                debugPrint("ERROR")
                return
            }

            self?.movies = searchResult
            self?.isLoading = false
        }
    }
}

// MARK: - Constants

fileprivate extension SearchInteractor {
    enum Constants {
        
    }
}
