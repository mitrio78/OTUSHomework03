//
//  OMDBSearchParams.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 29.08.2023.
//

import CoreServicesTest

struct OMDBSearchParams: SearchParametersProtocol {
    var netProtocol: NetworkProtocol = .http
    var httpMethod: HTTPMethod = .get
    var host: String = "www.omdbapi.com"
    var path: String = ""
    var parameters: [String : String]? = [
        "apikey": Tokens.rapidAPIKey
    ]
    var headers: [String : String]?

    private enum Tokens {
        static let rapidAPIKey: String = "c9f524bd"
    }
}
