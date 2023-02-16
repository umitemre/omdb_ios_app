//
//  MovieDetailRepository.swift
//  OMDP
//
//  Created by Emre Aydin on 13.02.2023.
//

import Foundation

class MovieDetailRepository {
    func fetchMovieDetail(for imdbId: String, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        NetworkLayer.shared
            .url("https://www.omdbapi.com/")
            .addQueryParam(key: "i", value: imdbId)
            .makeRequest { (result: Result<MovieDetail, Error>) in
                completion(result)
            }
    }
}

protocol MovieDetailRepositoryInjected { }

extension MovieDetailRepositoryInjected {
    var movieDetailRepository: MovieDetailRepository {
        MovieDetailRepository()
    }
}
