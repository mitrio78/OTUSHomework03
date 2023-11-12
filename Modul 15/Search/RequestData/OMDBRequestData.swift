//
//  OMDBRequestData.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 12.11.2023.
//

import CoreServicesTest
import Foundation

struct OMDBRequestData: RequestDataProtocol {
    var scheme: CoreServicesTest.Scheme? = .http
    var baseURL: String? = "www.omdbapi.com"
    var port: Int?
    var urlPath: String = ""
    var method: CoreServicesTest.HTTPMethod = .get
    var headers: [String : String]?
    var requestGetParams: [String : String]? = [
        "apikey": Tokens.rapidAPIKey
    ]
    var bodyParams: Encodable?
    var forceURLString: String?
    
    private enum Tokens {
        static let rapidAPIKey: String = "c9f524bd"
    }
}
