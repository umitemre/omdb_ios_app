//
//  SearchResult.swift
//  OMDP
//
//  Created by Emre Aydin on 12.02.2023.
//

import Foundation

struct SearchResult: Codable {
    let search: [Search]?
    let totalResults, response: String?

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}
