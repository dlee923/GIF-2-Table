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
        self.backgroundColor = .orange
    }
    
    let categoryBar = CategoryBar()
    
    func setUpView() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.alpha = 1
        }) { (finished) in
            self.setUpCategoryBarView()
        }
    }
    
    func setUpCategoryBarView() {
        self.addSubview(categoryBar)
        categoryBar.translatesAutoresizingMaskIntoConstraints = false
        categoryBar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        categoryBar.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        categoryBar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        categoryBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        let categoryBarCells = categoryBar.visibleCells
        
        for cell in categoryBarCells {
            cell.alpha = 0
        }
        
//        var animationDelay: Double = 0.5
//        let animationDelayIncrement: Double = 1
//        
//        for cell in categoryBarCells {
//            UIView.animate(withDuration: 0.5, delay: animationDelay, options: .curveLinear, animations: {
//                cell.alpha = 1
//            }, completion: nil)
//            
//            animationDelay += animationDelayIncrement
//        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
