//
//  DislikedRecipe+CoreDataProperties.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 5/15/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import Foundation
import CoreData


extension DislikedRecipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DislikedRecipe> {
        return NSFetchRequest<DislikedRecipe>(entityName: "DislikedRecipe")
    }

    @NSManaged public var recipeTitle: String?

}
