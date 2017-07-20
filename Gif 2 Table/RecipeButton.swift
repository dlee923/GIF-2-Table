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
    let unhighlightedColor = globalButtonTintColor
    
    let firebaseManager = Firebase()
    let coreDataManager = CoreDataManager()
    
    var recipeObj: RecipeObject?
    
    var listedView: MainRecipeCell?
    var mainViewController: MainVC?
    var opposingButton: RecipeButton?
    
    fileprivate func setUpButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setTintColor() {
        self.tintColor = isSelected ? highlightedColor : unhighlightedColor
    }

    
    func checkIfLiked() {
        let likedIndex = self.mainViewController?.likedRecipes.index(where: { (recipe) -> Bool in
            recipe.recipeTitle == self.recipeObj?.recipeTitle
        })
        if likedIndex != nil {
            print("liked exists \(likedIndex ?? 0)")
            self.isSelected = true
        }        
        setTintColor()
    }
    
    func checkIfDisliked() {
        let dislikedIndex = self.mainViewController?.dislikedRecipes.index(where: { (recipe) -> Bool in
            recipe.recipeTitle == self.recipeObj?.recipeTitle
        })
        if dislikedIndex != nil {
            print("dislike exists \(dislikedIndex ?? 0)")
            self.isSelected = true
        }
        setTintColor()
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
        
        setTintColor()
    }
    
    func addLikeFunction(isThumbsUp: Bool) {
        if isThumbsUp {
            self.addTarget(self, action: #selector(self.likeBtnPressed), for: .touchUpInside)
        } else {
            self.addTarget(self, action: #selector(self.dislikeBtnPressed), for: .touchUpInside)
        }
    }
    
    func addFavoriteFunction() {
        self.addTarget(self, action: #selector(self.favoriteBtnPressed), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
