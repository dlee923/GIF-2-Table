//
//  LikedRecipe+CoreDataProperties.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 5/15/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import Foundation
import CoreData


extension LikedRecipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikedRecipe> {
        return NSFetchRequest<LikedRecipe>(entityName: "LikedRecipe")
    }

    @NSManaged public var recipeTitle: String?

}
