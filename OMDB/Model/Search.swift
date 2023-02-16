//
//  Search.swift
//  OMDP
//
//  Created by Emre Aydin on 12.02.2023.
//

import Foundation

struct Search: Codable {
    let title, year, imdbID: String?
    let type: TypeEnum?
    let poster: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
    
    init(from movieDetailLocal: MovieDetailLocal) {
        self.imdbID = movieDetailLocal.imdbId
        self.title = movieDetailLocal.title
        self.poster = movieDetailLocal.poster

        self.year = nil
        self.type = nil
    }
}

enum TypeEnum: String, Codable {
    case movie = "movie"
    case series = "series"
    case game = "game"
}
