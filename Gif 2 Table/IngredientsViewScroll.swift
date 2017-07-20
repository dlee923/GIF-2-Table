//
//  IngredientsViewScroll.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 7/17/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

extension IngredientsView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let startPosition = recipeView?.ingredientViewStart {
            let moveRecipeView = startPosition - (scrollView.contentOffset.y + startPosition)
            recipeView?.ingredientViewTopAnchor?.constant = moveRecipeView
            
            let blurPercentage = (startPosition - moveRecipeView) / startPosition
            recipeView?.blurView.alpha = blurPercentage
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let startPosition = recipeView?.ingredientViewStart {
            if scrollView.contentOffset.y < (-startPosition + 100) {
                scrollView.setContentOffset(CGPoint(x: 0, y: -startPosition), animated: true)
            }
        }
    }
}
