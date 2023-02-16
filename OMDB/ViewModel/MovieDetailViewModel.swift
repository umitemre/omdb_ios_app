//
//  MovieDetailViewModel.swift
//  OMDP
//
//  Created by Emre Aydin on 12.02.2023.
//

import Foundation
import RxSwift

class MovieDetailViewModel: MovieDetailRepositoryInjected {
    private var _movieDetailResult = ReplaySubject<MovieDetail>.create(bufferSize: 1)
    var movieDetailResult: Observable<MovieDetail> {
        get {
            return _movieDetailResult
        }
    }
    
    func fetchMovieDetail(for imdbId: String) {
        movieDetailRepository.fetchMovieDetail(for: imdbId) { [weak self] data in
            switch(data) {
            case .success(let data):
                self?._movieDetailResult.onNext(data)
            case .failure(let error):
                fatalError("Error can not be accepted at this moment: \(error)")
            }
        }
    }
}
