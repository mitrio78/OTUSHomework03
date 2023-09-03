//
//  SearchParameters.swift
//
//  Created by Dmitriy Grishechko on 14.05.2023.
//

import Foundation

// MARK: - Search Parameters Protocol

protocol SearchParametersProtocol {
    var netProtocol: NetworkProtocol { get }
    var httpMethod: HTTPMethod { get }
    var host: String { get }
    var path: String { get set }
    var parameters: [String : String]? { get }
    var headers: [String: String]? { get }
}
