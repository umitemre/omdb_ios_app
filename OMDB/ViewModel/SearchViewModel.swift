//
//  SearchViewModel.swift
//  OMDP
//
//  Created by Emre Aydin on 15.02.2023.
//

import UIKit
import RxSwift

class SearchViewModel {
    private var _recentlyViewedMovies = ReplaySubject<[MovieDetailLocal]>.create(bufferSize: 1)
    var recentlyViewedMovies: Observable<[MovieDetailLocal]> {
        get {
            return _recentlyViewedMovies
        }
    }

    func fetchRecentlyViewed() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request = MovieDetailLocal.fetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: false)
        ]

        guard let items = try? context.fetch(request) else {
            return
        }
        
        _recentlyViewedMovies.onNext(items)
    }
}
