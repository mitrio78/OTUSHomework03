//
//  SearchProtocols.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 08.11.2023.
//

import Foundation

// MARK: - SearchViewModelProtocol

protocol SearchViewModelProtocol: MovieCellDelegate {
    var moviesPublisher: Published<[MovieDisplayModel]>.Publisher { get }
    var searchTypePublisher: Published<SearchServiceType>.Publisher { get }
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    
    func addToFavorites(_ index: Int)
    func searchMovie(_ searchText: String)
    func toggleSearchService()
}
