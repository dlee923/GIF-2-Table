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
    
    var mainVC: MainVC?
    
    func downloadData(completion: @escaping ([RecipeObject]) -> ()) {
        
        var recipes = [RecipeObject]()
        
        FIRDatabase.database().reference().child("Recipes").observe(.childAdded, with: { (snapshot) in
            //parse data here
            if let recipeValues = snapshot.value as? [String: Any] {
                
                if let title = recipeValues["title"] as? String,
                    let link = recipeValues["gifLink"] as? String,
                    let ingredients = recipeValues["ingredients"] as? [[String: String]],
                    let image = recipeValues["image"] as? String,
                    let likes = recipeValues["likes"] as? Int,
                    let dislikes = recipeValues["dislikes"] as? Int
                {
                    
                    var ingredientArr = [[String: String]]()
                    
                    for ingredient in ingredients {
                        ingredientArr.append(ingredient)
                    }
                    
                    let recipe = RecipeObject(link: link, title: title, imageLink: image, ingredients: ingredientArr, favorite: false, like: false, dislike: false, likes: likes, dislikes: dislikes, child: snapshot.key, mainVC: self.mainVC!)
                    print("successful instantiation of recipeObj")
                    
                    recipes.append(recipe)
                }
            }
            DispatchQueue.main.async {
                completion(recipes.reversed())
            }
            
        }, withCancel: nil)
    }
    
    func pushLikeDislikeValue(recipe: RecipeObject) {
        if let recipeInDatabase = recipe.recipeChild, let link = recipe.recipeLink, let imageLink = recipe.recipeImageLink, let recipeTitle = recipe.recipeTitle, let ingredients = recipe.recipeIngredients, let likes = recipe.likes, let dislikes = recipe.dislikes {
            let recipeDatabase = FIRDatabase.database().reference().child("Recipes").child(recipeInDatabase)
            
            let values = ["dislikes": dislikes, "gifLink": link, "image": imageLink, "likes": likes, "title": recipeTitle, "ingredients": ingredients] as [String : Any]
            
            print(values)
            recipeDatabase.updateChildValues(values) { (err, ref) in
                print("finished pushing to server")
            }
        }
    }
    
//    func updateIngredients(completion: @escaping ([String:[String:String]]) -> ()) {
//        var ingredients = [String:[String:String]]()
//        FIRDatabase.database().reference().child("Ingredients").observeSingleEvent(of: .value, with: { (snapshot) in
//            if let ingredientTypes = snapshot.value as? [String: Any] {
//                for eachIngredient in ingredientTypes {
//                    guard let values = eachIngredient.value as? [String: Any], let name = eachIngredient.key as? String else { return }
//                    guard let description = values["Description"] as? String, let image = values["Image"] as? String else { return }
//                    ingredients[name] = ["Description" : description, "Image" : image]
//                }
//            }
//            DispatchQueue.main.async {
//                print(ingredients.count)
//                completion(ingredients)
//            }
//            
//        }, withCancel: nil)
//    }
    
}
