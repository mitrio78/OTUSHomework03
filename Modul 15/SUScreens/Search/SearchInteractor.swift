//
//  SearchInteractor.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 08.11.2023.
//

import Foundation

final class SearchInteractor: ObservableObject {

    @Published var results: [MovieGridModel] = [
        MovieGridModel(id: "1", image: "rocky", title: "Rocky", description: "Sport drama about boxer...", fullDescription: ""),
        MovieGridModel(id: "2", image: "silence", title: "Silence", description: "Thriller about cannibal", fullDescription: "")
    ]
}
