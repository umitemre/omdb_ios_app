//
//  SearchMovieViewController.swift
//  OMDP
//
//  Created by Emre Aydin on 12.02.2023.
//

import Foundation
import RxSwift

class SearchMovieViewModel : SearchMovieRepositoryInjected {
    private var _searchMovieResult = ReplaySubject<SearchResult>.create(bufferSize: 1)
    var searchMovieResult: Observable<SearchResult> {
        get {
            return _searchMovieResult
        }
    }
    
    private var isLoading = false

    func fetchSearchResults(for query: String, page: Int) {
        self.isLoading = true

        self.searchRepository.fetchSearchResults(for: query, page: page) { [weak self] data in
            switch(data) {
            case .success(let data):
                self?._searchMovieResult.onNext(data)
            case .failure(let error):
                fatalError("Error can not be accepted at this moment: \(error)")
            }

            self?.isLoading = false
        }
    }
}
