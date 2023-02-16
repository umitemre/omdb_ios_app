//
//  MovieDetailViewModel.swift
//  OMDP
//
//  Created by Emre Aydin on 12.02.2023.
//

import Foundation
import RxSwift

class MovieDetailViewModel: MovieDetailRepositoryInjected {
    private var _movieDetailResult = ReplaySubject<Result<MovieDetail, Error>>.create(bufferSize: 1)
    var movieDetailResult: Observable<Result<MovieDetail, Error>> {
        get {
            return _movieDetailResult
        }
    }
    
    func fetchMovieDetail(for imdbId: String) {
        movieDetailRepository.fetchMovieDetail(for: imdbId) { [weak self] data in
            self?._movieDetailResult.onNext(data)
        }
    }
}
