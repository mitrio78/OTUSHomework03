//
//  SearchListCell.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 08.11.2023.
//

import SwiftUI

struct SearchListCell: View {

    // MARK: - Properties

    let movie: MovieGridModel

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(movie.image)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 120)
                .cornerRadius(6)

            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.accentColor)

                Text(movie.description)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .padding(.trailing, 8)
            }
        } //: HStack
    }
}

struct SearchListCell_Previews: PreviewProvider {
    static var previews: some View {
        SearchListCell(movie: MovieGridModel(id: "1", image: "rocky", title: "Rocky", description: "Some description Some description Some description Some description"))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
