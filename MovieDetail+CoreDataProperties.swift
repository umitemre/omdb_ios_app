//
//  MovieDetail+CoreDataProperties.swift
//  OMDP
//
//  Created by Emre Aydin on 15.02.2023.
//
//

import Foundation
import CoreData


extension MovieDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieDetail> {
        return NSFetchRequest<MovieDetail>(entityName: "MovieDetail")
    }

    @NSManaged public var imdbId: String?
    @NSManaged public var title: String?
    @NSManaged public var poster: String?

}

extension MovieDetail : Identifiable {

}
