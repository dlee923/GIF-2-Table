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
                removeLike(likeButton: self)
            }
        }
        
        if let dislikeButton = self.opposingButton {
            if dislikeButton.isSelected {
                removeDislike(dislikeButton: dislikeButton)
            }
        }
        
        setTintColor()
    }
    
    func removeLike(likeButton: RecipeButton) {
        var count = Int((recipeObj?.likes)!)
        
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
        
        likeButton.isSelected = false
        likeButton.setTintColor()
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
                removeDislike(dislikeButton: self)
            }
        }
        
        if let likeButton = self.opposingButton {
            if likeButton.isSelected {
                removeLike(likeButton: likeButton)
            }
        }
        
        setTintColor()
    }
    
    func removeDislike(dislikeButton: RecipeButton) {
        var count = Int((recipeObj?.dislikes)!)
        
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
        
        dislikeButton.isSelected = false
        dislikeButton.setTintColor()
    }
    
    
    
    func removeFromFavorites() {
        let favIndex = self.mainViewController?.favoriteRecipes.index(where: { (recipe) -> Bool in
            recipe.recipeTitle == self.recipeObj?.recipeTitle
        })
        
        print("this recipe was located on the favorite array at index: \(favIndex ?? 0)")
        
        if let titleToRemove = self.mainViewController?.favoriteRecipes[favIndex!].recipeTitle {
            coreDataManager.deleteData(recipeTitle: titleToRemove, entityName: "RecipeModel")
        }
        
        self.mainViewController?.favoriteRecipes.remove(at: favIndex!)
        if mainViewController?.mainCollectionView.isFavorites == true {
            self.mainViewController?.mainCollectionView.collectionView?.reloadData()
        }
        
        setTintColor()
    }
    
    func favoriteBtnPressed(){
        if !self.isSelected {
            print("adding to favorites")
            if let object = self.recipeObj {
                object.favorite = true
                self.mainViewController?.favoriteRecipes.append(object)
                coreDataManager.saveData(recipe: object, recipeModel: true, recipeLike: false, recipeDislike: false)
            }
            self.isSelected = true
        } else {
            print("removing from favorites")
            self.recipeObj?.favorite = false
            removeFromFavorites()
            self.isSelected = false
        }
        
        let favMessage = self.isSelected ? "Recipe added to your favorites!" : "Recipe removed from favorites."
        // call dialogue MDC component
        setTintColor()
    }
}
