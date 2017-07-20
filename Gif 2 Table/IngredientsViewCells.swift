//
//  IngredientsViewCells.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 7/17/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class IngredientHeader: BaseCell {
    
    override func setUpCell() {
        self.backgroundColor = .white
        self.addSubview(ingredientsTitleLabel)
        self.addSubview(ingredientsTitleArrow)
        
        ingredientsTitleArrow.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        ingredientsTitleArrow.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        ingredientsTitleArrow.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        ingredientsTitleArrow.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2).isActive = true
        
        ingredientsTitleLabel.leadingAnchor.constraint(equalTo: ingredientsTitleArrow.trailingAnchor).isActive = true
        ingredientsTitleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        ingredientsTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        ingredientsTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        setUpSeparator()
    }
    
    func setUpSeparator() {
        let separator = UIView()
        self.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = globalButtonTintColor
        separator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separator.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
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
        arrow.setImage(UIImage(named: "ic_chevron_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
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
