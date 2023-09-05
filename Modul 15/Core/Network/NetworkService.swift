//
//  NetworkService.swift
//
//  Created by Dmitriy Grishechko on 11.05.2023.
//

import UIKit

// MARK: - Network API Service

final class NetworkService: NetworkServiceProtocol {

    // MARK: - Methods

    func loadData(urlString: String, completion: ((Data?) -> Void)?) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard
                let url = URL(string: urlString),
                let data = try? Data(contentsOf: url)
            else {
                debugPrint("Ошибка, не удалось загрузить изображение")
                DispatchQueue.main.async {
                    completion?(nil)
                }
                return
            }

            DispatchQueue.main.async {
                completion?(data)
            }
        }
    }

    func getSearchResults<Response: Decodable>(
        _ type: Response.Type,
        searchParams: SearchParametersProtocol,
        completion: @escaping (Response?, Error?) -> Void
    ) {
        var urlComponents = URLComponents()
        urlComponents.scheme = searchParams.netProtocol.rawValue
        urlComponents.host = searchParams.host
        urlComponents.path = searchParams.path
        var queryItems: [URLQueryItem] = []

        if let parameters = searchParams.parameters {
            parameters.forEach { name, value in
                queryItems.append(URLQueryItem(name: name, value: value))
            }
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else {
            fatalError()
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = searchParams.httpMethod.rawValue
        urlRequest.timeoutInterval = 10
        urlRequest.allHTTPHeaderFields = searchParams.headers

        debugPrint("URL: \(url)")

        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.global(qos: .background).async {
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    debugPrint(error?.localizedDescription ?? "Error data")
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(type, from: data)
                    DispatchQueue.main.async {
                        completion(model, error)
                    }
                } catch {
                    debugPrint("Data error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
}
