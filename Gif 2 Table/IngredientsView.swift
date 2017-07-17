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

class IngredientHeader: BaseCell {

    override func setUpCell() {
        self.backgroundColor = .white
        self.addSubview(ingredientsTitleLabel)
        self.addSubview(ingredientsTitleArrow)
        
        ingredientsTitleArrow.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        ingredientsTitleArrow.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        ingredientsTitleArrow.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        ingredientsTitleArrow.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2).isActive = true
        
        ingredientsTitleLabel.leadingAnchor.constraint(equalTo: ingredientsTitleArrow.trailingAnchor).isActive = true
        ingredientsTitleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        ingredientsTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        ingredientsTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    var recipeView: RecipeView?
    
    lazy var ingredientsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ingredients"
        label.font = fontPorter?.withSize(15)
        label.textColor = tintedBlack
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ingredientsTitleArrow: UIButton = {
        let arrow = UIButton()
        arrow.setImage(UIImage(named: "arrow1")?.withRenderingMode(.alwaysTemplate), for: .normal)
        arrow.imageView?.contentMode = .scaleAspectFit
        arrow.tintColor = tintedBlack
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.addTarget(self, action: #selector(self.removeRecipeView), for: .touchUpInside)
        return arrow
    }()
    
    func removeRecipeView() {
        recipeView?.removeFromSuperview()
    }
    
}


class IngredientCell: BaseCell {
    
    override func setUpCell() {
        self.backgroundColor = .white
        let whiteSpacer = UIView()
        whiteSpacer.backgroundColor = .white
        
        self.addSubview(whiteSpacer)
        self.addSubview(ingredientLabel)
        self.addSubview(checkOffButton)
        self.addSubview(measurement)
        
        addConstraintsWithFormat(format: "H:|[v0(75)][v3(15)][v1][v2(40)]|", views: measurement, ingredientLabel, checkOffButton, whiteSpacer)
        
        for eachView in self.subviews {
            addConstraintsWithFormat(format: "V:|-[v0]|", views: eachView)
        }
    }
    
    var ingredient: IngredientObject? {
        didSet {
            ingredientLabel.text = ingredient?.name
            measurement.text = "\(ingredient!.measurement)"
        }
    }
    
    let labelFont = fontReno?.withSize(10)
    
    lazy var ingredientLabel: UILabel = {
        let label = UILabel()
        label.font = self.labelFont
        label.backgroundColor = .white
        return label
    }()
    
    lazy var checkOffButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(UIImage(named: "noCheck"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(self.checkOff), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        return button
    }()
    
    lazy var measurement: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = self.labelFont
        label.backgroundColor = .white
        return label
    }()
    
    var isPressed = false
    
    var recipeName: String?
    
    func checkOff() {
        if isPressed {
            checkOffButton.setImage(UIImage(named: "noCheck"), for: .normal)
            isPressed = false
        } else {
            checkOffButton.setImage(UIImage(named: "check"), for: .normal)
            isPressed = true
        }
    }
}

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }
    
    func setUpCell() {
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
