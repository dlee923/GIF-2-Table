//
//  RecipeView.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 7/16/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class RecipeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = globalBackgroundColor
        setUpView()
    }
    
    var recipe: RecipeObject? {
        didSet {
            recipe?.downloadCoverImage { (image) in
                self.recipeImage.image = image
            }
            ingredientList?.recipe = self.recipe
        }
    }
    
    var mainVC: MainVC?
    let imageHeight: CGFloat = 0.45
    let ingredientViewSideSpacer: CGFloat = 15
    let statusBarSideSpacer: CGFloat = 10
    var ingredientViewStart: CGFloat?
    
    let recipeImage: UIImageView = {
        let _recipeImage = UIImageView()
        _recipeImage.clipsToBounds = true
        _recipeImage.contentMode = .scaleAspectFill
        return _recipeImage
    }()
    
    lazy var blurView: UIVisualEffectView = {
        let blur = UIVisualEffectView()
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        blur.alpha = 0
        return blur
    }()
    
    let ingredientView: UIView = {
        let _ingredientView = UIView()
        _ingredientView.backgroundColor = .white
        return _ingredientView
    }()
    
    lazy var ingredientList: IngredientsView? = {
        let _ingredientList = IngredientsView()
        _ingredientList.recipeView = self
        return _ingredientList
    }()
    
    let statusBar = StatusBar()
    
    var ingredientViewTopAnchor: NSLayoutConstraint?
    
    func setUpView() {
        guard let _ingredientList = ingredientList else { return }
        
        self.addSubview(recipeImage)
        recipeImage.addSubview(blurView)
        self.addSubview(ingredientView)
        self.addSubview(statusBar)
        self.addSubview(_ingredientList)
        
        for view in self.subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        recipeImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        recipeImage.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        recipeImage.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        recipeImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: imageHeight).isActive = true
        
        blurView.heightAnchor.constraint(equalTo: recipeImage.heightAnchor).isActive = true
        blurView.widthAnchor.constraint(equalTo: recipeImage.widthAnchor).isActive = true
        
        ingredientViewStart = (self.frame.height * imageHeight) - 30
        print("inset = \(ingredientViewStart)")
        // if this doesn't work - then resort to using the mainVC frame?
        
        ingredientView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ingredientViewSideSpacer).isActive = true
        ingredientView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -ingredientViewSideSpacer).isActive = true
        ingredientView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        ingredientViewTopAnchor = ingredientView.topAnchor.constraint(equalTo: self.topAnchor, constant: ingredientViewStart ?? 0)
        ingredientViewTopAnchor?.isActive = true
        
        statusBar.leadingAnchor.constraint(equalTo: ingredientView.leadingAnchor, constant: statusBarSideSpacer).isActive = true
        statusBar.trailingAnchor.constraint(equalTo: ingredientView.trailingAnchor, constant: -statusBarSideSpacer).isActive = true
        statusBar.bottomAnchor.constraint(equalTo: ingredientView.bottomAnchor, constant: -ingredientViewSideSpacer).isActive = true
        statusBar.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1).isActive = true
        
        _ingredientList.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        _ingredientList.leadingAnchor.constraint(equalTo: ingredientView.leadingAnchor, constant: statusBarSideSpacer).isActive = true
        _ingredientList.trailingAnchor.constraint(equalTo: ingredientView.trailingAnchor, constant: -statusBarSideSpacer).isActive = true
        _ingredientList.bottomAnchor.constraint(equalTo: statusBar.topAnchor).isActive = true
        _ingredientList.contentInset = UIEdgeInsetsMake(ingredientViewStart ?? 0, 0, 0, 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
