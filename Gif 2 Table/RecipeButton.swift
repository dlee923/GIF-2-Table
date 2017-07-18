//
//  RecipeButton.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 7/18/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class RecipeButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButton()
    }
    
    let highlightedColor = tintedBlack
    let unhighlightedColor = globalBackgroundColor
    
    let firebaseManager = Firebase()
    let coreDataManager = CoreDataManager()
    
    var recipeObj: RecipeObject?
    
    var listedView: MainRecipeCell?
    var mainViewController: MainVC?
    
    fileprivate func setUpButton() {
        self.tintColor = isSelected ? highlightedColor : unhighlightedColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    
    func checkIfLiked() {
        let likedIndex = self.mainViewController?.likedRecipes.index(where: { (recipe) -> Bool in
            recipe.recipeTitle == self.recipeObj?.recipeTitle
        })
        
        if likedIndex != nil {
            print("liked exists \(likedIndex ?? 0)")
            self.isSelected = true
            self.isSelected = false
        }
        
        let dislikedIndex = self.mainViewController?.dislikedRecipes.index(where: { (recipe) -> Bool in
            recipe.recipeTitle == self.recipeObj?.recipeTitle
        })
        
        if dislikedIndex != nil {
            print("dislike exists \(dislikedIndex ?? 0)")
            self.isSelected = false
            self.isSelected = true
        }
    }
    
    
    func checkIfFavorite() {
        let favoriteIndex = self.mainViewController?.favoriteRecipes.index(where: { (recipe) -> Bool in
            recipe.recipeTitle == self.recipeObj?.recipeTitle
        })
        
        if favoriteIndex != nil {
            print("favorite exists \(favoriteIndex ?? 0)")
            self.isSelected = true
        } else {
            self.isSelected = false
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
