//
//  Rating.swift
//  OMDP
//
//  Created by Emre Aydin on 12.02.2023.
//

import Foundation

struct Rating: Codable {
    let source, value: String?

    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}
