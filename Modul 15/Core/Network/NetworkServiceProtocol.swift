//
//  Protocols.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 03.09.2023.
//

import UIKit

// MARK: - NetworkServiceProtocol

protocol NetworkServiceProtocol {

    func loadImage(urlString: String, completion: ((Data?) -> Void)?)

    func getSearchResults<Response: Decodable>(
        _ type: Response.Type,
        searchParams: SearchParametersProtocol,
        completion: @escaping (Response?, Error?) -> Void
    )
}
