//
//  IngredientsView.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 4/21/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class IngredientsView: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        
        setUpIngredientsCv()
    }
    
    var recipe: RecipeObject? {
        didSet {
            //when set, update ingredients array which will feed into the collectionView
            guard let ingredients = recipe?.recipeIngredients else { return }
            parseRawIngredients(ingredients: ingredients)
        }
    }
    
    var ingredients: [IngredientObject]? {
        didSet {
            self.reloadData()
        }
    }
    
    var recipeView: RecipeView?
    
    let ingredientCell = "ingredientCell"
    let defaultCell = "defaultCell"
    let headerCellID = "headerCellID"
    
    func parseRawIngredients(ingredients: [[String: String]]) {
        self.ingredients = [IngredientObject]()
        
        for ingredient in ingredients {
            if let type = ingredient["type"], let measure = ingredient["measurement"] {
                let ingredientObj = IngredientObject(name: type, imageName: "", measurement: measure)
                self.ingredients?.append(ingredientObj)
            }
        }
    }
    
    func setUpIngredientsCv() {
        self.register(IngredientCell.self, forCellWithReuseIdentifier: ingredientCell)
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: defaultCell)
        self.register(IngredientHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCellID)
        
        self.showsVerticalScrollIndicator = false
        self.flashScrollIndicators()
        self.backgroundColor = .clear
        self.delegate = self
        self.dataSource = self
    }
    
    //------------------------------------------------
    // COLLLECTION VIEW DATASOURCE + DELEGATE METHODS
    //------------------------------------------------
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.frame.width, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCellID, for: indexPath) as? IngredientHeader {
            header.recipeView = self.recipeView
            self.recipeView?.ingredientListHeader = header
            return header
        }
        
        return IngredientHeader()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ingredientCell, for: indexPath) as? IngredientCell {
            cell.ingredient = ingredients?[indexPath.item]
            if cell.recipeName != recipe?.recipeTitle {
                cell.checkOffButton.setImage(UIImage(named: "noCheck"), for: .normal)
                cell.isPressed = false
                cell.recipeName = recipe?.recipeTitle
            }
            
            return cell
            
        } else {
            print("no cell found")
            return collectionView.dequeueReusableCell(withReuseIdentifier: defaultCell, for: indexPath)
        }
    }
    
    //------------------------------------------------
    // INGREDIENTS VIEW TOUCH METHODS
    //------------------------------------------------
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
