//
//  SearchMovieViewController.swift
//  OMDP
//
//  Created by Emre Aydin on 12.02.2023.
//

import Foundation
import RxSwift

class ResultsViewModel : SearchMovieRepositoryInjected {
    private var _searchMovieResult = ReplaySubject<Result<SearchResult, Error>>.create(bufferSize: 1)
    var searchMovieResult: Observable<Result<SearchResult, Error>> {
        get {
            return _searchMovieResult
        }
    }
    
    private var isLoading = false

    func fetchSearchResults(for query: String, page: Int) {
        self.isLoading = true

        self.searchRepository.fetchSearchResults(for: query, page: page) { [weak self] data in
            self?._searchMovieResult.onNext(data)
            self?.isLoading = false
        }
    }
}
