//
//  RecipeModel+CoreDataProperties.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 5/15/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import Foundation
import CoreData


extension RecipeModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeModel> {
        return NSFetchRequest<RecipeModel>(entityName: "RecipeModel")
    }

    @NSManaged public var favorite: Bool
    @NSManaged public var isDisliked: Bool
    @NSManaged public var isLiked: Bool
    @NSManaged public var recipeImageLink: String?
    @NSManaged public var recipeIngredients: [[String: String]]?
    @NSManaged public var recipeLink: String?
    @NSManaged public var recipeTitle: String?
    @NSManaged public var recipeChild: String?

}
