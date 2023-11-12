//
//  KinopoiskSearchRequestData.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 12.11.2023.
//

import CoreServicesTest
import Foundation

struct KinopoiskSearchRequestData: RequestDataProtocol {
    var scheme: CoreServicesTest.Scheme? = .http
    var baseURL: String? = "api.kinopoisk.dev"
    var forceURLString: String? = nil
    var port: Int?
    var urlPath: String = "/v1.2/movie/search"
    var method: CoreServicesTest.HTTPMethod = .get
    var headers: [String : String]? = [:]
    var requestGetParams: [String : String]? = [
        "token": Tokens.apiKey
    ]
    var bodyParams: Encodable?

    private enum Tokens {
        static let apiKey: String = "JBEVWXE-K7TMKHH-G5Y8P32-K6JAQ8J"
    }
}
