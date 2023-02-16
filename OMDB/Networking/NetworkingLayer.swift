//
//  NetworkingLayer.swift
//  OMDP
//
//  Created by Emre Aydin on 12.02.2023.
//

import Foundation
import Alamofire

class NetworkLayer {
    private var url: String?
    private var queryItems: [URLQueryItem] = []

    private var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
              let apiKey = dict["API_KEY"] as? String else {
                  fatalError("API_KEY not found in Info.plist")
              }
        
        return apiKey
    }
    
    static let shared: NetworkLayer = NetworkLayer()

    private init() {}
    
    func url(_ url: String) -> NetworkLayer {
        self.queryItems = []
        self.url = url
        return self
    }

    func addQueryParam(key: String, value: String) -> NetworkLayer {
        self.queryItems.append(URLQueryItem(name: key, value: value))
        return self
    }

    func makeRequest<T: Decodable>(completion: @escaping (_ data: Result<T, Error>) -> Void) {
        guard let url = self.url else {
            fatalError("URL is not provided or something is wrong with it")
        }

        self.queryItems.append(URLQueryItem(name: "apikey", value: apiKey))

        var urlComponents = URLComponents(string: url)
        urlComponents?.queryItems = self.queryItems

        guard let finalUrl = urlComponents?.url else {
            fatalError("Failed to add compile query parameters to URL")
        }

        AF.request(finalUrl)
            .validate()
            .responseDecodable(of: T.self) { (response) in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
