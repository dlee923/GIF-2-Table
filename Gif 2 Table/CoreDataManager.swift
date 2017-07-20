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
    
    var mainVC: MainVC?
    
    func saveData(recipe: RecipeObject, recipeModel: Bool, recipeLike: Bool, recipeDislike: Bool) {
        
        if recipeModel == true {
            let recipeToSave = RecipeModel(context: context!)
            recipeToSave.favorite = recipe.favorite!
            recipeToSave.isDisliked = recipe.isDisliked!
            recipeToSave.isLiked = recipe.isLiked!
            recipeToSave.recipeLink = recipe.recipeLink!
            recipeToSave.recipeTitle = recipe.recipeTitle!
            recipeToSave.recipeImageLink = recipe.recipeImageLink!
            recipeToSave.recipeIngredients = recipe.recipeIngredients!
            recipeToSave.recipeChild = recipe.recipeChild!
        }
        
        if recipeLike == true {
            let recipeToSave = LikedRecipe(context: context!)
            recipeToSave.recipeTitle = recipe.recipeTitle!
        }
        
        if recipeDislike == true {
            let recipeToSave = DislikedRecipe(context: context!)
            recipeToSave.recipeTitle = recipe.recipeTitle!
        }
        
        do {
            try context?.save()
            print("save successful")
        } catch let err {
            print(err)
        }
    }
    

    
    func deleteData(recipeTitle: String, entityName: String) {
        
        if entityName == "RecipeModel" {
            let request = NSFetchRequest<RecipeModel>(entityName: entityName)
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
        } else if entityName == "LikedRecipe" {
            let request = NSFetchRequest<LikedRecipe>(entityName: entityName)
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
        } else if entityName == "DislikedRecipe" {
            let request = NSFetchRequest<DislikedRecipe>(entityName: entityName)
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
        
        
    }
    
    func loadData(entityName: String) -> [RecipeObject] {
        var recipeArr = [RecipeObject]()
        
        switch entityName {
            case "RecipeModel": print("Loading favorites")
            
            let request = NSFetchRequest<RecipeModel>(entityName: entityName)
            request.fetchLimit = 10
            do {
                if let recipes = try context?.fetch(request) {
                    for recipe in recipes {
                        let loadRecipe = RecipeObject(link: recipe.recipeLink!, title: recipe.recipeTitle!, imageLink: recipe.recipeImageLink!, ingredients: recipe.recipeIngredients!, favorite: recipe.favorite, like: recipe.isLiked, dislike: recipe.isDisliked, likes: 0, dislikes: 0, child: recipe.recipeChild!, mainVC: mainVC!, category: " ")
                        
                        recipeArr.append(loadRecipe)
                    }
                }
            } catch let err { print(err) }
            
            
            case "LikedRecipe": print("Loading likes")
            
            let request = NSFetchRequest<LikedRecipe>(entityName: entityName)
            request.fetchLimit = 10
            do {
                if let recipes = try context?.fetch(request) {
                    for recipe in recipes {
                        let loadRecipe = RecipeObject(link: " ", title: recipe.recipeTitle!, imageLink: " ", ingredients: [["":""]], favorite: false, like: true, dislike: true, likes: 0, dislikes: 0, child: " ", mainVC: mainVC!, category: " ")
                        recipeArr.append(loadRecipe)
                    }
                }
            } catch let err { print(err) }
            
            
            case "DislikedRecipe": print("Loading dislikes")
            
            let request = NSFetchRequest<DislikedRecipe>(entityName: entityName)
            request.fetchLimit = 10
            do {
                if let recipes = try context?.fetch(request) {
                    for recipe in recipes {
                        let loadRecipe = RecipeObject(link: " ", title: recipe.recipeTitle!, imageLink: " ", ingredients: [["":""]], favorite: false, like: true, dislike: true, likes: 0, dislikes: 0, child: " ", mainVC: mainVC!, category: " ")
                        recipeArr.append(loadRecipe)
                    }
                }
            } catch let err { print(err) }
            
        default: break
        }
        
        
        return recipeArr
    }
}
