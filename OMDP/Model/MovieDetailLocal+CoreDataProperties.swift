//
//  MovieDetailLocal+CoreDataProperties.swift
//  OMDP
//
//  Created by Emre Aydin on 15.02.2023.
//
//

import Foundation
import CoreData


extension MovieDetailLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieDetailLocal> {
        return NSFetchRequest<MovieDetailLocal>(entityName: "MovieDetailLocal")
    }

    @NSManaged public var imdbId: String?
    @NSManaged public var title: String?
    @NSManaged public var poster: String?

}

extension MovieDetailLocal : Identifiable {

}
