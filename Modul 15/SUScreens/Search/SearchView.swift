//
//  SearchView.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 08.11.2023.
//

import SwiftUI

struct SearchView: View {

    // MARK: - Properties

    @StateObject var interactor: SearchInteractor

    // MARK: - Body

    var body: some View {
        List {
            ForEach(interactor.results) { movie in
                NavigationLink(destination: DetailsView()) {
                    SearchListCell(movie: movie)
                }
            }
        }
        .listStyle(.plain)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(interactor: SearchInteractor())
    }
}
