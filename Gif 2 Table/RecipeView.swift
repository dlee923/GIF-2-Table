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
        self.alpha = 0
        setUpView()
    }
    
    var recipe: RecipeObject? {
        didSet {
            recipe?.downloadCoverImage { (image) in
                self.recipeImage.image = image
            }
            ingredientList?.recipe = self.recipe
            statusBar.recipe = self.recipe
        }
    }
    
    var mainVC: MainVC? {
        didSet {
            statusBar.mainVC = self.mainVC            
        }
    }
    
    var recipeCell: StockMDCCell?
    
    let imageHeight: CGFloat = 0.45
    let ingredientViewSideSpacer: CGFloat = 15
    let statusBarSideSpacer: CGFloat = 10
    var ingredientViewStart: CGFloat?
    
    let recipeCanvas = UIView()
    
    let recipeImage: UIImageView = {
        let _recipeImage = UIImageView()
        _recipeImage.alpha = 0
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
        
        UIView.animate(withDuration: 0.2, animations: {
            // add faux image
            
            self.backgroundColor = globalBackgroundColor
            self.alpha = 1
            
        }) { (_) in
            // add elements offscreen
            self.addViewElements()
            self.recipeCanvas.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
            
            UIView.animate(withDuration: 0.25, animations: { 
                 // animate faux image into position
                
            }, completion: { (_) in
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.recipeCanvas.transform = CGAffineTransform.identity
                }, completion: { (_) in
                    self.recipeImage.alpha = 1
                    // remove faux image
                })
            })
        }
    }
    
    func addViewElements() {
        guard let _ingredientList = ingredientList else { return }
        
        self.addSubview(recipeCanvas)
        recipeCanvas.addSubview(recipeImage)
        recipeImage.addSubview(blurView)
        recipeCanvas.addSubview(ingredientView)
        recipeCanvas.addSubview(statusBar)
        recipeCanvas.addSubview(_ingredientList)
        
        recipeCanvas.translatesAutoresizingMaskIntoConstraints = false
        
        for view in recipeCanvas.subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        recipeCanvas.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        recipeCanvas.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        recipeImage.topAnchor.constraint(equalTo: recipeCanvas.topAnchor).isActive = true
        recipeImage.leadingAnchor.constraint(equalTo: recipeCanvas.leadingAnchor).isActive = true
        recipeImage.trailingAnchor.constraint(equalTo: recipeCanvas.trailingAnchor).isActive = true
        recipeImage.heightAnchor.constraint(equalTo: recipeCanvas.heightAnchor, multiplier: imageHeight).isActive = true
        
        blurView.heightAnchor.constraint(equalTo: recipeImage.heightAnchor).isActive = true
        blurView.widthAnchor.constraint(equalTo: recipeImage.widthAnchor).isActive = true
        
        ingredientViewStart = (self.frame.height * imageHeight) - 30
        print("inset = \(ingredientViewStart)")
        // if this doesn't work - then resort to using the mainVC frame?
        
        ingredientView.leadingAnchor.constraint(equalTo: recipeCanvas.leadingAnchor, constant: ingredientViewSideSpacer).isActive = true
        ingredientView.trailingAnchor.constraint(equalTo: recipeCanvas.trailingAnchor, constant: -ingredientViewSideSpacer).isActive = true
        ingredientView.bottomAnchor.constraint(equalTo: recipeCanvas.bottomAnchor).isActive = true
        ingredientViewTopAnchor = ingredientView.topAnchor.constraint(equalTo: recipeCanvas.topAnchor, constant: ingredientViewStart ?? 0)
        ingredientViewTopAnchor?.isActive = true
        
        statusBar.leadingAnchor.constraint(equalTo: ingredientView.leadingAnchor, constant: statusBarSideSpacer).isActive = true
        statusBar.trailingAnchor.constraint(equalTo: ingredientView.trailingAnchor, constant: -statusBarSideSpacer).isActive = true
        statusBar.bottomAnchor.constraint(equalTo: ingredientView.bottomAnchor, constant: -ingredientViewSideSpacer).isActive = true
        statusBar.heightAnchor.constraint(equalTo: recipeCanvas.heightAnchor, multiplier: 0.1).isActive = true
        
        _ingredientList.topAnchor.constraint(equalTo: recipeCanvas.topAnchor).isActive = true
        _ingredientList.leadingAnchor.constraint(equalTo: ingredientView.leadingAnchor, constant: statusBarSideSpacer).isActive = true
        _ingredientList.trailingAnchor.constraint(equalTo: ingredientView.trailingAnchor, constant: -statusBarSideSpacer).isActive = true
        _ingredientList.bottomAnchor.constraint(equalTo: statusBar.topAnchor).isActive = true
        _ingredientList.contentInset = UIEdgeInsetsMake(ingredientViewStart ?? 0, 0, 0, 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
