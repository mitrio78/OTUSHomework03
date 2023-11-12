//
//  GetImageRequestData.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 12.11.2023.
//

import CoreServicesTest
import Foundation

struct GetImageRequestData: RequestDataProtocol {
    var scheme: CoreServicesTest.Scheme?
    var baseURL: String?
    var port: Int?
    var urlPath: String
    var method: CoreServicesTest.HTTPMethod = .get
    var headers: [String : String]?
    var requestGetParams: [String : String]?
    var bodyParams: Encodable?
    var forceURLString: String?
}
