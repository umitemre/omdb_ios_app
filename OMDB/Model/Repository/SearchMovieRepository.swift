//
//  SearchMovieRepository.swift
//  OMDP
//
//  Created by Emre Aydin on 12.02.2023.
//

import Foundation

class SearchMovieRepository {
    func fetchSearchResults(for query: String, page: Int, completion: @escaping (Result<SearchResult, Error>) -> Void) {
        NetworkLayer.shared
            .url("https://www.omdbapi.com/")
            .addQueryParam(key: "s", value: query)
            .addQueryParam(key: "page", value: "\(page)")
            .makeRequest { (result: Result<SearchResult, Error>) in
                completion(result)
            }
    }
}

protocol SearchMovieRepositoryInjected { }

extension SearchMovieRepositoryInjected {
    var searchRepository: SearchMovieRepository {
        SearchMovieRepository()
    }
}
