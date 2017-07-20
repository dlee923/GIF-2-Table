//
//  CategoryBarView.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 7/17/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class CategoryBarView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.alpha = 0
        self.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    let categoryBar = CategoryBar()
    var categoryBarHeight: CGFloat = 0.15
    
    func setUpView() {
        UIView.animate(withDuration: 0.15, animations: {
            self.alpha = 1
        }) { (finished) in
            
            self.setUpCategoryBarView()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.0, execute: {
                self.fadeIn()
            })
        }
    }
    
    func fadeIn() {
        let categoryBarCells = categoryBar.visibleCells
        
        var animationDelay: Double = 0.0
        let animationDelayIncrement: Double = 0.1
        
        for cell in categoryBarCells {
            UIView.animate(withDuration: 0.2, delay: animationDelay, options: .curveLinear, animations: {
                cell.alpha = 1
            }, completion: nil)
            
            animationDelay += animationDelayIncrement
        }
    }
    
    func setUpCategoryBarView() {
        self.addSubview(categoryBar)
        categoryBar.translatesAutoresizingMaskIntoConstraints = false
        categoryBar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        categoryBar.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        categoryBar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        categoryBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
