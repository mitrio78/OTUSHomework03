//
//  KinoPoiskModel.swift
//
//  Created by Dmitriy Grishechko on 14.05.2023.
//

import Foundation

struct KinoPoiskResponse: Decodable {
    let docs: [Kino]
}

struct Kino: Decodable {
    let id: Int
    let name: String
    let description: String
    let shortDescription: String?
    let poster: String?
}
