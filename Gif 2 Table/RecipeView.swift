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
        self.backgroundColor = .clear
    }
    
    var recipe: RecipeObject? {
        didSet {
            recipe?.downloadCoverImage(completion: { (image, sameTitle) in
                self.recipeImage.image = image
            })
            
            ingredientList?.recipe = self.recipe
            statusBar.recipe = self.recipe            
        }
    }
    
    var mainVC: MainVC? {
        didSet {
            statusBar.mainVC = self.mainVC            
        }
    }
    
    var recipeCell: StockMDCCell? {
        didSet {
            setUpView()
            addSwipeGestureToRemoveView()
        }
    }
    
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
    
    var ingredientListHeader: IngredientHeader?
    
    let statusBar = StatusBar()
    
    var ingredientViewTopAnchor: NSLayoutConstraint?
    
    let swipeView = UIView()
    
    func createFauxImage() -> UIImageView {
        if let cell = self.recipeCell as? MainRecipeCell {
            let cellImageFrame = cell.convert(cell.recipeImage.frame, to: nil)
            let fauxImage = UIImageView(frame: cellImageFrame)
            fauxImage.contentMode = .scaleAspectFill
            fauxImage.layer.cornerRadius = 4
            fauxImage.clipsToBounds = true
            fauxImage.image = cell.recipeImage.image
            return fauxImage
        } else if let cell = self.recipeCell as? FeaturedRecipeCell {
            let cellImageFrame = cell.convert(cell.recipeImage.frame, to: nil)
            let fauxImage = UIImageView(frame: cellImageFrame)
            fauxImage.contentMode = .scaleAspectFill
            fauxImage.layer.cornerRadius = 4
            fauxImage.clipsToBounds = true
            fauxImage.image = cell.recipeImage.image
            return fauxImage
        }
        
        return UIImageView()
    }
    
    func setUpView() {
        
        var fauxImg: UIImageView?
        
        UIView.animate(withDuration: 0.2, animations: {
            // add faux image
            fauxImg = self.createFauxImage()
            
            self.addSubview(fauxImg!)
            
            self.backgroundColor = globalBackgroundColor
            
        }) { (_) in
            // add elements offscreen
            self.addViewElements()
            self.recipeCanvas.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
            
            
            
            UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
                fauxImg?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height * self.imageHeight)
            }, completion: { (_) in
                UIView.animate(withDuration: 0.25, animations: {
                    self.recipeCanvas.transform = CGAffineTransform.identity
                }, completion: { (_) in
                    self.recipeImage.alpha = 1
                    fauxImg?.removeFromSuperview()
                })
            })
        }
        
        
    }
    
    func addViewElements() {
        guard let _ingredientList = ingredientList else { return }
        
        self.addSubview(recipeCanvas)
        recipeCanvas.addSubview(recipeImage)
        recipeImage.addSubview(blurView)
        
        swipeView.frame = CGRect(x: 0, y: 0, width: self.frame.width / 5, height: self.frame.height)
        recipeCanvas.addSubview(self.swipeView)
        
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
    
    func swipeToRemoveView() {
        self.statusBar.slideOffRecipe(shouldRemove: true, recipeView: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
