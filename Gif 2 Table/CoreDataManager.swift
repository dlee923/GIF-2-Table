//
//  CoreDataManager.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 5/11/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    override init() {
        super.init()
        // create instance of contextManager
        if let contextManager = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            context = contextManager
        } else {
            print("error - no core data persistent container")
        }
    }
    
    var context: NSManagedObjectContext?
    
    func saveData(recipe: RecipeObject) {
        let recipeToSave = RecipeModel(context: context!)
        recipeToSave.favorite = recipe.favorite!
        recipeToSave.isDisliked = recipe.isDisliked!
        recipeToSave.isLiked = recipe.isLiked!
        recipeToSave.recipeLink = recipe.recipeLink!
        recipeToSave.recipeTitle = recipe.recipeTitle!
        recipeToSave.recipeImageLink = recipe.recipeImageLink!
        recipeToSave.recipeIngredients = recipe.recipeIngredients!
        
        do {
            try context?.save()
            print("save successful")
        } catch let err {
            print(err)
        }
    }
    
    func deleteData(recipeTitle: String) {
        let request = NSFetchRequest<RecipeModel>(entityName: "RecipeModel")
        request.predicate = NSPredicate(format: "recipeTitle = %@", recipeTitle)
        request.fetchLimit = 1
        
        do {
            if let recipeToDelete = try context?.fetch(request) {
                context?.delete(recipeToDelete.first!)
                print("deletion successful")
                try context?.save()
            }
            
        } catch let err {
            print(err)
        }
    }
    
    func loadData() -> [RecipeObject] {
        let request = NSFetchRequest<RecipeModel>(entityName: "RecipeModel")
        request.fetchLimit = 10
        
        var recipeArr = [RecipeObject]()
        
        do {
            if let recipes = try context?.fetch(request) {
                for recipe in recipes {
                    let loadRecipe = RecipeObject(link: recipe.recipeLink!, title: recipe.recipeTitle!, imageLink: recipe.recipeImageLink!, ingredients: recipe.recipeIngredients!, favorite: recipe.favorite, like: recipe.isLiked, dislike: recipe.isDisliked)
                    recipeArr.append(loadRecipe)
                }
            }
        } catch let err { print(err) }
        
        return recipeArr
    }
}
