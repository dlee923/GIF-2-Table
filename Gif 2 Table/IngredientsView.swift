//
//  IngredientsView.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 4/21/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class IngredientsView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpIngredientsCv()
        setUpIngredientsView()
    }
    
    var recipe: RecipeObject? {
        didSet {
            //when set, update ingredients array which will feed into the collectionView
            guard let ingredients = recipe?.recipeIngredients else { return }
            parseRawIngredients(ingredients: ingredients)
        }
    }
    
    func parseRawIngredients(ingredients: [String]) {
        self.ingredients = [IngredientObject]()
        
        for ingredient in ingredients {
            let ingredientObj = IngredientObject(name: ingredient, measurement: "?")
            self.ingredients?.append(ingredientObj)
        }
    }
    
    var recipeView: RecipeView?
    var ingredients: [IngredientObject]?
    let arrowColor = UIColor.white
    let ingredientsTitleFont = fontHello?.withSize(25)
    let ingredientCardInset: CGFloat = 5
    let ingredientListBackgroundClr = UIColor.lightGray
    
    lazy var ingredientsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ingredients"
        label.font = self.ingredientsTitleFont
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .black
        return label
    }()
    
    lazy var ingredientsTitleArrow: UIImageView = {
        let arrow = UIImageView()
        arrow.contentMode = .scaleAspectFit
        arrow.image = UIImage(named: "arrow1")?.withRenderingMode(.alwaysTemplate)
        arrow.tintColor = self.arrowColor
        return arrow
    }()
    
    lazy var ingredientsList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = self.ingredientListBackgroundClr
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    var ingredientCell = "ingredientCell"
    var defaultCell = "defaultCell"    
    
    fileprivate func setUpIngredientsView() {
        self.addSubview(ingredientsTitleLabel)
        ingredientsTitleLabel.addSubview(ingredientsTitleArrow)
        self.addSubview(ingredientsList)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: ingredientsTitleLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: ingredientsList)
        addConstraintsWithFormat(format: "V:|[v0(55)]", views: ingredientsTitleLabel)
        addConstraintsWithFormat(format: "V:|-55-[v0]|", views: ingredientsList)
        
        ingredientsTitleLabel.addConstraintsWithFormat(format: "H:[v0(50)]-|", views: ingredientsTitleArrow)
        ingredientsTitleLabel.addConstraintsWithFormat(format: "V:|-[v0]-|", views: ingredientsTitleArrow)
    }
    
    func setUpIngredientsCv() {
        ingredientsList.register(IngredientCell.self, forCellWithReuseIdentifier: ingredientCell)
        ingredientsList.register(UICollectionViewCell.self, forCellWithReuseIdentifier: defaultCell)
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ingredientCell, for: indexPath) as? IngredientCell {
            cell.ingredient = ingredients?[indexPath.item]
            return cell
        
        } else {
            print("no cell found")
            return collectionView.dequeueReusableCell(withReuseIdentifier: defaultCell, for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ingredientsList.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //------------------------------------------------
    // INGREDIENTS VIEW TOUCH METHODS
    //------------------------------------------------
    
    var originalLocation: CGPoint?
    var firstTouchPoint: CGPoint?
    var isScrollingUp: Bool?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        originalLocation = self.center
        if let firstTouch = touches.first?.location(in: recipeView) {
            print("set first touch point: \(firstTouch)")
            firstTouchPoint = firstTouch
        }
        recipeView?.mainViewController?.collectionView?.isScrollEnabled = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchPoint = touches.first?.location(in: recipeView) {
            
            let yPointDistance = touchPoint.y - (firstTouchPoint?.y)!
            
            let moveXPoint = (originalLocation?.x)!
            let moveYPoint = (originalLocation?.y)! + yPointDistance
            
            let moveToPoint = CGPoint(x: moveXPoint, y: moveYPoint)
            self.center = moveToPoint
            
            //Setting scroll direction so touches ended can place final position
            if yPointDistance < 0 {
                isScrollingUp = true
            } else {
                isScrollingUp = false
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        recipeView?.mainViewController?.collectionView?.isScrollEnabled = true
        
        // final position
        guard let isScrollDirectionUp = isScrollingUp else { return }
        
        if isScrollDirectionUp {
            guard let maxPosition = self.recipeView?.yConstantMaxPosition else { return }
            self.recipeView?.ingredientsViewCenterY?.constant = maxPosition
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.ingredientsTitleArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }, completion: nil)
            
            print("push to top!")
            
        } else if !isScrollDirectionUp {
            guard let startPosition = self.recipeView?.yConstantStartPosition else { return }
            self.recipeView?.ingredientsViewCenterY?.constant = startPosition
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.ingredientsTitleArrow.layer.transform = CATransform3DIdentity
            }, completion: nil)
            
            print("push to bottom!")
        }
        
        UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
            self.superview?.layoutIfNeeded()
        }, completion: nil )                
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class IngredientCell: BaseCell {
    
    override func setUpCell() {
        self.addSubview(ingredientLabel)
        self.addSubview(whatIsThisButton)
        self.addSubview(measurement)
        
        addConstraintsWithFormat(format: "H:|-[v0(75)][v1][v2(40)]-|", views: measurement, ingredientLabel, whatIsThisButton)
        
        for eachView in self.subviews {
            addConstraintsWithFormat(format: "V:|-[v0]|", views: eachView)
        }
    }
    
    var ingredient: IngredientObject? {
        didSet {
            ingredientLabel.text = ingredient?.name
            measurement.text = "\(ingredient!.measurement)   -  "
        }
    }
    
    let labelFont = fontHello?.withSize(15)
    
    lazy var ingredientLabel: UILabel = {
        let label = UILabel()
        label.font = self.labelFont
        label.backgroundColor = .white
        return label
    }()
    
    let whatIsThisButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(UIImage(named: "huh"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    lazy var measurement: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = self.labelFont
        label.backgroundColor = .white
        return label
    }()
}
