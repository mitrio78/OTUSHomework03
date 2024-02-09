//
//  SearchViewModel.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 08.11.2023.
//

import Combine
import Foundation

// MARK: - SearchViewModel

final class SearchViewModel: ObservableObject {
    
    // MARK: - Dependencies
    
    @Injected private var apiService: SearchAPIServiceProtocol!
    @Injected private var storage: FavoritesServiceProtocol!
    
    // MARK: - Properties

    @Published private(set) var movies: [MovieDisplayModel] = []
    @Published private(set) var searchType: SearchServiceType = .omdb
    @Published private(set) var isLoading: Bool = false

    private var timer: Timer?
}

// MARK: - SearchViewModelProtocol

extension SearchViewModel: SearchViewModelProtocol {
    var moviesPublisher: Published<[MovieDisplayModel]>.Publisher {
        $movies
    }
    
    var searchTypePublisher: Published<SearchServiceType>.Publisher {
        $searchType
    }
    
    var isLoadingPublisher: Published<Bool>.Publisher {
        $isLoading
    }
    
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

extension SearchViewModel: MovieCellDelegate {
    func uploadImages(for id: String, image urlString: String) async throws -> Data? {
        if let cachedImage = movies.first(where: { $0.id == id })?.image {
            return cachedImage
        }

        let imageData = try await apiService.getImages(imageUrl: urlString)

        DispatchQueue.main.async {
            if let index = self.movies.firstIndex(where: { $0.id == id }) {
                self.movies[index].image = imageData
            }
        }

        return imageData
    }
}

// MARK: - Private Methods

fileprivate extension SearchViewModel {

    func resetData() {
        movies = []
    }

    func fetchData(searchText: String) {
        Task { @MainActor in
            do {
                switch searchType {
                case .kinopoisk:
                    let result = try await apiService.getKinoPoiskResults(searchString: searchText)
                    movies = buildMoviesViewModel(from: result)
                    isLoading = false

                case .omdb:
                    let result = try await apiService.getOMDBResults(searchString: searchText)
                    movies = buildMoviesViewModel(from: result)
                    isLoading = false
                }

            } catch {
                debugPrint("Search error: \(error.localizedDescription)")
                isLoading = false
            }
        }
    }

    func buildMoviesViewModel(from model: KinoPoiskResponse) -> [MovieDisplayModel] {
        model.docs.map {
            MovieDisplayModel(
                id: "\($0.id)",
                imageURL: $0.poster,
                title: $0.name,
                description: $0.shortDescription ?? Constants.defaultDescription,
                fullDescription: $0.description
            )
        }
    }

    func buildMoviesViewModel(from model: OMDBResponse) -> [MovieDisplayModel] {
        model.results.map {
            MovieDisplayModel(
                id: $0.imdbID ?? "",
                imageURL: $0.imageUrl,
                title: $0.title ?? "",
                description: $0.title ?? Constants.defaultDescription,
                fullDescription: "\($0.year ?? ""). \($0.title ?? "")"
            )
        }
    }
}

// MARK: - Constants

fileprivate extension SearchViewModel {
    enum Constants {
        static let defaultDescription: String = "Tap to see more details..."
    }
}
