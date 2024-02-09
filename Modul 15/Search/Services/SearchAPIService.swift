//
//  SearchAPIService.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 12.11.2023.
//

import CoreServicesTest
import Foundation

enum TopLayerNetError: Error {
    case castingError
}

protocol SearchAPIServiceProtocol {
    func getKinoPoiskResults(searchString: String) async throws -> KinoPoiskResponse
    func getOMDBResults(searchString: String) async throws -> OMDBResponse
    func getImages(imageUrl: String) async throws -> Data
}

final class SearchAPIService: SearchAPIServiceProtocol {

    @Injected var networkService: NetworkServiceProtocol!

    func getKinoPoiskResults(searchString: String) async throws -> KinoPoiskResponse {
        var request = KinopoiskSearchRequestData()
        request.requestGetParams?.updateValue(searchString, forKey: "query")
        return try await networkService.makeRequest(request: request, responseType: KinoPoiskResponse.self)
    }

    func getOMDBResults(searchString: String) async throws -> OMDBResponse {
        var request = OMDBRequestData()
        request.requestGetParams?.updateValue(searchString, forKey: "s")
        return try await networkService.makeRequest(request: request, responseType: OMDBResponse.self)
    }

    func getImages(imageUrl: String) async throws -> Data {
        let request = GetImageRequestData(urlPath: "", forceURLString: imageUrl)
        return try await networkService.makeDataRequest(request: request)
    }
}
