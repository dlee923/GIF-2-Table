//
//  RecipeButtonHelpers.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 7/18/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

extension RecipeButton {
    
    func likeBtnPressed() {
        print("Happy face")
        var count = Int((recipeObj?.likes)!)
        
        if let object = self.recipeObj {
            if !self.isSelected {
                self.recipeObj?.isLiked = true
                // increase count + push to server
                count += 1
                listedView?.likeCountLabel.text = "\(count)"
                recipeObj?.likes = count
                firebaseManager.pushLikeDislikeValue(recipe: self.recipeObj!)
                
                self.mainViewController?.likedRecipes.append(object)
                coreDataManager.saveData(recipe: object, recipeModel: false, recipeLike: true, recipeDislike: false)
                
                self.isSelected = true
            } else if self.isSelected {
                self.recipeObj?.isLiked = false
                //decrease count + push to server
                count -= 1
                listedView?.likeCountLabel.text = "\(count)"
                recipeObj?.likes = count
                firebaseManager.pushLikeDislikeValue(recipe: self.recipeObj!)
                
                let likedIndex = self.mainViewController?.likedRecipes.index(where: { (recipe) -> Bool in
                    recipe.recipeTitle == self.recipeObj?.recipeTitle
                })
                if likedIndex != nil {
                    self.mainViewController?.likedRecipes.remove(at: likedIndex!)
                    coreDataManager.deleteData(recipeTitle: (self.recipeObj?.recipeTitle)!, entityName: "LikedRecipe")
                }
                
                self.isSelected = false
            }
        }
    }
    
    func dislikeBtnPressed() {
        print("Sad face")
        var count = Int((recipeObj?.dislikes)!)
        
        if let object = self.recipeObj {
            if !self.isSelected {
                self.recipeObj?.isDisliked = true
                //increase count + push to server
                count += 1
                listedView?.dislikeCountLabel.text = "\(count)"
                recipeObj?.dislikes = count
                firebaseManager.pushLikeDislikeValue(recipe: self.recipeObj!)
                
                self.mainViewController?.dislikedRecipes.append(object)
                coreDataManager.saveData(recipe: object, recipeModel: false, recipeLike: false, recipeDislike: true)
                
                self.isSelected = true
            } else if self.isSelected {
                self.recipeObj?.isDisliked = false
                //decrease count + push to server
                count -= 1
                listedView?.dislikeCountLabel.text = "\(count)"
                recipeObj?.dislikes = count
                firebaseManager.pushLikeDislikeValue(recipe: self.recipeObj!)
                
                let dislikedIndex = self.mainViewController?.dislikedRecipes.index(where: { (recipe) -> Bool in
                    recipe.recipeTitle == self.recipeObj?.recipeTitle
                })
                if dislikedIndex != nil {
                    self.mainViewController?.dislikedRecipes.remove(at: dislikedIndex!)
                    coreDataManager.deleteData(recipeTitle: (self.recipeObj?.recipeTitle)!, entityName: "DislikedRecipe")
                }
                
                self.isSelected = false
            }
        }
    }
}
