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
                let ingredients = recipeValues["ingredients"] as? [String: Any],
                    let image = recipeValues["image"] as? String,
                    let like = recipeValues["like"] as? Bool,
                    let dislike = recipeValues["dislike"] as? Bool,
                    let fav = recipeValues["fav"] as? Bool
                {
                    
                    var ingredientArr = [String]()
                    
                    for ingredient in ingredients {
                        ingredientArr.append(ingredient.value as! String)
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
    
    func updateIngredients() {
        FIRDatabase.database().reference().child("Ingredients").observeSingleEvent(of: .value, with: { (snapshot) in
            if let ingredientTypes = snapshot.value as? [String: Any] {
                print(ingredientTypes)
                for eachIngredient in ingredientTypes {
                    
                    if let values = eachIngredient.value as? [String: Any], let name = eachIngredient.key as? String {
                        print(name)
                        if let descripton = values["Description"], let image = values["Image"] {
                            print(descripton)
                            print(image)
                        }
                    }
//                    print(eachIngredient)
//                    if let description = eachIngredient["Description"], let image = eachIngredient["Image"] {
//                        print("success2")
//                        print(description)
//                        print(image)
//                    }
                }
                
            }
        }, withCancel: nil)
    }
    
}
