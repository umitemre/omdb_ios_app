//
//  CoreDataManager.swift
//  OMDP
//
//  Created by Emre Aydin on 16.02.2023.
//

import UIKit
import CoreData

class CoreDataManager {
    private var context: NSManagedObjectContext!

    static let shared = CoreDataManager()

    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func saveMovieDetail(_ search: Search?) {
        self.checkRemoveExistingMovieDetail(search?.imdbID)

        let movieDetailLocal = MovieDetailLocal(context: context)
        movieDetailLocal.title = search?.title
        movieDetailLocal.poster = search?.poster
        movieDetailLocal.imdbId = search?.imdbID
        movieDetailLocal.timestamp = .now

        try? context.save()
        
        self.removeOverflowMovieDetail()
    }

    private func checkRemoveExistingMovieDetail(_ imdbId: String?) {
        guard let imdbId = imdbId else {
            return
        }

        let fetchRequest: NSFetchRequest<MovieDetailLocal> = MovieDetailLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imdbId == %@", imdbId)

        let results = try? context.fetch(fetchRequest)
        
        if let existingMovieDetail = results?.first {
            context.delete(existingMovieDetail)
        }
    }

    private func removeOverflowMovieDetail() {
        guard let items = try? context.fetch(MovieDetailLocal.fetchRequest()) else {
            return
        }

        if items.count <= 10 {
            return
        }

        // Remove last
        guard let last = items.last else {
            return
        }
        
        context.delete(last)
    }
}
