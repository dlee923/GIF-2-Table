//
//  FeatureCell.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 4/27/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class FeatureCell: BaseCell {
    
    var cellMainViewController: MainVC? {
        didSet {
            recipeView.mainViewController = self.cellMainViewController
        }
    }
    
    lazy var recipeView: RecipeView = {
        let view = RecipeView()
        view.backgroundColor = .orange
        return view
    }()
    
    fileprivate func setUpRecipeView(viewToAdd: UIView) {
        viewToAdd.addSubview(recipeView)
        viewToAdd.addConstraintsWithFormat(format: "H:|[v0]|", views: recipeView)
        viewToAdd.addConstraintsWithFormat(format: "V:|[v0]|", views: recipeView)
    }
    
    override func setUpCell() {
        setUpRecipeView(viewToAdd: self)
//        recipeView.addPlayButton(viewToAddTo: self)
//        bringSubview(toFront: recipeView.ingredientsView)
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
