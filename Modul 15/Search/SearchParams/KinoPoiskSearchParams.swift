//
//  KinoPoiskSearchParams.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 29.08.2023.
//

struct KinoPoiskSearchParams: SearchParametersProtocol {
    var netProtocol: NetworkProtocol = .https
    var httpMethod: HTTPMethod = .get
    var host: String = "api.kinopoisk.dev"
    var path: String = "/v1.2/movie/search"
    var parameters: [String : String]? = [
        "token": Tokens.apiKey
    ]
    var headers: [String : String]?

    private enum Tokens {
        static let apiKey: String = "JBEVWXE-K7TMKHH-G5Y8P32-K6JAQ8J"
    }
}
