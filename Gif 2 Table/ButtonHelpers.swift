//
//  ButtonHelpers.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 7/17/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

extension Buttons {

    func activateMenu() {
        guard let main = mainVC else { return }
        guard let window = UIApplication.shared.keyWindow else { return }
        
        bottomConstant = main.view.frame.height * buttonMenu.menuHeight
        
        if !isMenuActive {
            window.addSubview(menuShadowBackground)
            menuShadowBackground.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
            menuShadowBackground.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
            menuShadowBackground.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
            menuShadowBackground.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
            
            window.addSubview(buttonMenu)
            buttonMenu.heightAnchor.constraint(equalTo: window.heightAnchor, multiplier: buttonMenu.menuHeight).isActive = true
            buttonMenu.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: main.mainCollectionView.collectionViewSideBorders - 3).isActive = true
            buttonMenu.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -main.mainCollectionView.collectionViewSideBorders + 3).isActive = true
            bottomConstraint = buttonMenu.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: bottomConstant ?? 0)
            bottomConstraint?.isActive = true
            window.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
                self.menuShadowBackground.alpha = 1
                self.bottomConstraint?.constant = -main.mainCollectionView.collectionViewSideBorders + 3
                window.layoutIfNeeded()
            }) { (_) in
                self.isMenuActive = true
            }
        } else {
            dismissMenu()
        }
    }
    
    func dismissMenu() {
        guard let window = UIApplication.shared.keyWindow else { return }
        UIView.animate(withDuration: 0.3, animations: {
            
            if self.categoryBarView != nil {
                self.bottomConstraint?.constant = ((self.bottomConstant ?? 0) * 2) + 5
            } else {
                self.bottomConstraint?.constant = self.bottomConstant ?? 0
            }
            self.menuShadowBackground.alpha = 0
            window.layoutIfNeeded()
            
        }, completion: { (finished) in
            self.menuShadowBackground.removeFromSuperview()
            self.buttonMenu.removeFromSuperview()
            if let _categoryBarView = self.categoryBarView {
                _categoryBarView.removeFromSuperview()
                self.isFilterActive = false
            }
            self.isMenuActive = false
        })
    }
    
    
    
    func selectFilter() {
        guard let main = mainVC else { return }
        guard let window = UIApplication.shared.keyWindow else { return }
        
        if !isFilterActive {
            categoryBarView = CategoryBarView()
            categoryBarView?.translatesAutoresizingMaskIntoConstraints = false
            if categoryBarView != nil {
                window.addSubview(categoryBarView!)
                categoryBarView?.heightAnchor.constraint(equalTo: window.heightAnchor, multiplier: buttonMenu.menuHeight).isActive = true
                categoryBarView?.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: main.mainCollectionView.collectionViewSideBorders - 3).isActive = true
                categoryBarView?.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -main.mainCollectionView.collectionViewSideBorders + 3).isActive = true
                categoryBarView?.bottomAnchor.constraint(equalTo: buttonMenu.topAnchor, constant: -5).isActive = true
                categoryBarView?.setUpView()
            }
            isFilterActive = true
        } else {
            UIView.animate(withDuration: 0.3, animations: { 
                self.categoryBarView?.alpha = 0
            }, completion: { (_) in
                self.categoryBarView?.removeFromSuperview()
                self.isFilterActive = false
            })
        }
    }
    
    func selectFavorites() {
        if isFavoriteActive {
            return
        }
        print("favorites")
        self.isFavoriteActive = true
        
        guard let main = mainVC else { return }
        main.mainCollectionView.isFavorites = self.isFavoriteActive
        
//        UIView.animate(withDuration: 0.3, animations: { 
//            main.mainCVLeadingConstraint?.constant = main.view.frame.width
//            main.view.layoutIfNeeded()
//        }) { (finished) in
        
            main.mainCollectionView.recipes = main.recipes.filter({ (recipe) -> Bool in
                main.favoriteRecipes.contains(where: { (favRecipe) -> Bool in
                    favRecipe.recipeTitle == recipe.recipeTitle
                })
            })
        
            print(main.favoriteRecipes.count)
            print(main.mainCollectionView.recipes)
        
            main.mainCollectionView.collectionView?.reloadData()
 
//            UIView.animate(withDuration: 0.3, animations: {
//                main.mainCVLeadingConstraint?.constant = 0
//                main.view.layoutIfNeeded()                
//            }, completion: { (finished) in
//                // do something
//                
//            })
//        }
        activateMenu()
    }
    
    func selectHome() {
        if !isFavoriteActive {
            return
        }
        print("home")
        self.isFavoriteActive = false
        guard let main = mainVC else { return }
        main.mainCollectionView.isFavorites = self.isFavoriteActive
        main.mainCollectionView.recipes = main.recipes
        main.mainCollectionView.collectionView?.reloadData()
        
        activateMenu()
    }

}
