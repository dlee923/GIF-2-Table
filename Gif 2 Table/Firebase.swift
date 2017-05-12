//
//  Firebase.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 5/12/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import Foundation
import Firebase

class Firebase {
    
    func downloadData() {
        
        var recipes = [RecipeObject]()
        
        FIRDatabase.database().reference().child("Recipes").observe(.childAdded, with: { (snapshot) in
            //parse data here
            if let recipeValues = snapshot.value as? [String: Any] {
                
                if let title = recipeValues["title"] as? String,
                    let link = recipeValues["gifLink"] as? String,
                    let ingredients = recipeValues["ingredients"] as? [String: [String: String]],
                    let image = recipeValues["image"] as? String,
                    let like = recipeValues["like"] as? Bool,
                    let dislike = recipeValues["dislike"] as? Bool,
                    let fav = recipeValues["fav"] as? Bool
                {
                    
                    var ingredientArr = [[String: String]]()
                    
                    for (_, ingredient) in ingredients {
                        ingredientArr.append(ingredient)
                    }
                    
                    let recipe = RecipeObject(link: link, title: title, imageLink: image, ingredients: ingredientArr, favorite: fav, like: like, dislike: dislike)
                    print("successful instantiation of recipeObj")
//                    print(recipe.recipeTitle)
//                    print(recipe.recipeLink)
//                    print(recipe.recipeImageLink)
//                    print(recipe.recipeIngredients)
//                    print(recipe.favorite)
//                    print(recipe.isLiked)
//                    print(recipe.isDisliked)
                    
                    recipes.append(recipe)
                }
            }
            DispatchQueue.main.async {
                print("count \(recipes.count)")
            }
        }, withCancel: nil)
    }
    
    func updateIngredients(completion: @escaping ([String:[String:String]]) -> ()) {
        var ingredients = [String:[String:String]]()
        FIRDatabase.database().reference().child("Ingredients").observeSingleEvent(of: .value, with: { (snapshot) in
            if let ingredientTypes = snapshot.value as? [String: Any] {
                for eachIngredient in ingredientTypes {
                    guard let values = eachIngredient.value as? [String: Any], let name = eachIngredient.key as? String else { return }
                    guard let description = values["Description"] as? String, let image = values["Image"] as? String else { return }
                    ingredients[name] = ["Description" : description, "Image" : image]
                }
            }
            DispatchQueue.main.async {
                print(ingredients.count)
                completion(ingredients)
            }
            
        }, withCancel: nil)
    }
    
}
