//
//  MainCollectionVScroll.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 7/18/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

extension MainCollectionView {

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - (self.mainVC?.view.frame.height ?? 0)) {
            
            guard let count = self.recipes?.count else { return }
            if self.maxVisibleRecipes < count {
                self.maxVisibleRecipes += additionalRecipeIncremental
            }
        }
//        scrollNavTitleHandler(scrollView: scrollView)
    }
    
    func scrollNavTitleHandler(scrollView: UIScrollView) {
        let calculatedTrigger = scrollView.contentOffset.y >= CGFloat(250) ? false : true
        let trigger = self.mainVC?.titleViewFadeTrigger
        
        if calculatedTrigger == trigger {
            return
        } else {
            navTitleFadeControl(fadeLogo: trigger!)
            self.mainVC?.titleViewFadeTrigger = calculatedTrigger
        }
    }
    
    func navTitleFadeControl(fadeLogo: Bool) {
        if fadeLogo == true {
            UIView.animate(withDuration: 0.2, animations: {
                self.mainVC?.titleView.titleLabel.alpha = 0
            }) { (finished) in
                UIView.animate(withDuration: 0.25, animations: {
                    self.mainVC?.titleView.titleLogo.alpha = 1
                })
            }
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.mainVC?.titleView.titleLogo.alpha = 0
            }) { (finished) in
                UIView.animate(withDuration: 0.25, animations: {
                    self.mainVC?.titleView.titleLabel.alpha = 1
                })
            }
        }
    }
    
}
