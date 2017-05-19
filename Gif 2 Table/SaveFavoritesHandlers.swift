//
//  SaveFavoritesHandlers.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 5/19/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

extension SaveFavoritesView {
    
    func removeFromFavorites() {
        let favIndex = self.mainViewController?.favoriteRecipes.index(where: { (recipe) -> Bool in
            recipe.recipeTitle == self.recipeObj?.recipeTitle
        })
        
        print("this recipe was located on the favorite array at index: \(favIndex ?? 0)")
        
        if let titleToRemove = self.mainViewController?.favoriteRecipes[favIndex!].recipeTitle {
            coreDataManager.deleteData(recipeTitle: titleToRemove, entityName: "RecipeModel")
        }
        
        self.mainViewController?.favoriteRecipes.remove(at: favIndex!)
    }
    
    func favoriteBtnPressed(){
        print("btn pressed")
        pressedAnimation(object: favoriteBtn, needsReload: true)
        pressedAnimationText(object: favoriteText)
        
        if favoriteBtn.isSelected {
            print("adding to favorites")
            self.recipeObj?.favorite = true
            if let object = self.recipeObj {
                self.mainViewController?.favoriteRecipes.append(object)
                coreDataManager.saveData(recipe: object, recipeModel: true, recipeLike: false, recipeDislike: false)
            }
        } else {
            print("removing from favorites")
            self.recipeObj?.favorite = false
            removeFromFavorites()
        }
        
        favoriteBtn.tintColor = favoriteBtn.isSelected ? heartColor : defaultColor
        let favMessage = favoriteBtn.isSelected ? "I love this!  Adding to my favorites!" : "Blegh!! I got tired of this!"
        let promptView = PromptView()
        promptView.setUpPrompt(objectCalling: favoriteBtn, heightPct: 0.2, widthPct: 0.9, promptMsg: favMessage, messageLines: 2, messageOnly: true, doesDisappear: true)
    }
    
    func happyBtnPressed() {
        print("Happy face")
        var count = Int(happyText.text!)
        pressedAnimation(object: happyFace, needsReload: false)
        pressedAnimationText(object: likeText)
        pressedAnimationText(object: happyText)
        
        setHappyFaceColors()
        
        if let object = self.recipeObj {
            if happyFace.isSelected {
                self.recipeObj?.isLiked = true
                // increase count + push to server
                count! += 1
                happyText.text = "\(count!)"
                recipeObj?.likes = count!
                firebaseManager.pushLikeDislikeValue(recipe: self.recipeObj!)
                
                self.mainViewController?.likedRecipes.append(object)
                coreDataManager.saveData(recipe: object, recipeModel: false, recipeLike: true, recipeDislike: false)
            } else if happyFace.isSelected == false {
                self.recipeObj?.isLiked = false
                //decrease count + push to server
                count! -= 1
                happyText.text = "\(count!)"
                recipeObj?.likes = count!
                firebaseManager.pushLikeDislikeValue(recipe: self.recipeObj!)
                
                let likedIndex = self.mainViewController?.likedRecipes.index(where: { (recipe) -> Bool in
                    recipe.recipeTitle == self.recipeObj?.recipeTitle
                })
                if likedIndex != nil {
                    self.mainViewController?.likedRecipes.remove(at: likedIndex!)
                    coreDataManager.deleteData(recipeTitle: (self.recipeObj?.recipeTitle)!, entityName: "LikedRecipe")
                }
            }
        }
        
        if sadFace.isSelected {
            sadFace.isSelected = false
            self.recipeObj?.isDisliked = false
            setSadFaceColors()
            let dislikedIndex = self.mainViewController?.dislikedRecipes.index(where: { (recipe) -> Bool in
                recipe.recipeTitle == self.recipeObj?.recipeTitle
            })
            print("dislikeIndex: \(dislikedIndex)")
            if dislikedIndex != nil {
                self.mainViewController?.dislikedRecipes.remove(at: dislikedIndex!)
                coreDataManager.deleteData(recipeTitle: (self.recipeObj?.recipeTitle)!, entityName: "DislikedRecipe")
                //decrease count + push to server
                var count2 = Int(sadText.text!)
                count2! -= 1
                sadText.text = "\(count2!)"
                recipeObj?.dislikes = count!
                firebaseManager.pushLikeDislikeValue(recipe: self.recipeObj!)
            }
        }
    }
    
    func sadBtnPressed() {
        print("Sad face")
        var count = Int(sadText.text!)
        pressedAnimation(object: sadFace, needsReload: false)
        pressedAnimationText(object: sadText)
        pressedAnimationText(object: dislikeText)
        
        setSadFaceColors()
        
        if let object = self.recipeObj {
            if sadFace.isSelected {
                self.recipeObj?.isDisliked = true
                //increase count + push to server
                count! += 1
                sadText.text = "\(count!)"
                recipeObj?.dislikes = count!
                firebaseManager.pushLikeDislikeValue(recipe: self.recipeObj!)
                
                self.mainViewController?.dislikedRecipes.append(object)
                coreDataManager.saveData(recipe: object, recipeModel: false, recipeLike: false, recipeDislike: true)
            } else if sadFace.isSelected == false {
                self.recipeObj?.isDisliked = false
                //decrease count + push to server
                count! -= 1
                sadText.text = "\(count!)"
                recipeObj?.dislikes = count!
                firebaseManager.pushLikeDislikeValue(recipe: self.recipeObj!)
                
                let dislikedIndex = self.mainViewController?.dislikedRecipes.index(where: { (recipe) -> Bool in
                    recipe.recipeTitle == self.recipeObj?.recipeTitle
                })
                if dislikedIndex != nil {
                    self.mainViewController?.dislikedRecipes.remove(at: dislikedIndex!)
                    coreDataManager.deleteData(recipeTitle: (self.recipeObj?.recipeTitle)!, entityName: "DislikedRecipe")
                }
            }
        }
        
        if happyFace.isSelected {
            happyFace.isSelected = false
            self.recipeObj?.isLiked = false
            setHappyFaceColors()
            let likedIndex = self.mainViewController?.likedRecipes.index(where: { (recipe) -> Bool in
                recipe.recipeTitle == self.recipeObj?.recipeTitle
            })
            print("likedIndex: \(likedIndex)")
            if likedIndex != nil {
                self.mainViewController?.likedRecipes.remove(at: likedIndex!)
                coreDataManager.deleteData(recipeTitle: (self.recipeObj?.recipeTitle)!, entityName: "LikedRecipe")
                //decrease count + push to server
                var count2 = Int(happyText.text!)
                count2! -= 1
                happyText.text = "\(count2!)"
                recipeObj?.likes = count!
                firebaseManager.pushLikeDislikeValue(recipe: self.recipeObj!)
            }
        }
    }
    
    func generateRandomNumber() -> Int {
        guard let upperLimit = mainViewController?.recipes.count else { return 0 }
        let randomNumber = Int(arc4random_uniform(UInt32(upperLimit)))
        print(randomNumber)
        return randomNumber
    }

    func randomize() {
        print("Randomize")
        var randomNumber: Int?
        
        repeat { randomNumber = generateRandomNumber()
        } while previousRandomNumber == randomNumber
        previousRandomNumber = randomNumber
        
        if let randomRecipe = mainViewController?.recipes[randomNumber!] {
            mainViewController?.featureRecipe = randomRecipe
        }
        
        pressedAnimation(object: randomizeBtn, needsReload: true)
        pressedAnimationText(object: randomizeText)
    }
    
    func reset() {
        print("Reset")
        pressedAnimation(object: resetBtn, needsReload: false)
        pressedAnimationText(object: resetText)
        resetBtn.isUserInteractionEnabled = false
        let promptView = PromptView()
        promptView.mainViewController = self.mainViewController
        promptView.setUpPrompt(objectCalling: resetBtn, heightPct: 0.2, widthPct: 0.9, promptMsg: "Reset to the feature recipe?", messageLines: 2, messageOnly: false, doesDisappear: false)
    }

}
