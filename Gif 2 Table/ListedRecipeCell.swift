//
//  ListedRecipeCell.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 4/27/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import Foundation
import UIKit

class ListedRecipeCell: BaseCell {

    override func setUpCell() {
        self.addSubview(recipeLabel)
        self.addSubview(recipeImage)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: recipeLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: recipeImage)
        addConstraintsWithFormat(format: "V:|[v0(30)][v1]|", views: recipeLabel, recipeImage)
    }
    
    var recipe: RecipeObject? {
        didSet {
            //when set, call load ingredients list
            loadRecipeImage()
            recipeLabel.text = recipe?.recipeTitle
        }
    }
    
    func loadRecipeImage() {
        recipe?.downloadCoverImage(completion: { (coverImage) in
            self.recipeImage.image = coverImage
        })
    }
    
    var historyFavCell: HistoryFavoritesCell?
    
    let recipeLabel: UILabel = {
        let label = UILabel()
        label.font = fontMessy?.withSize(15)
        label.backgroundColor = UIColor.darkGray.withAlphaComponent(0.75)
        label.text = "RECIPE TEXT GOES HERE"
        return label
    }()
    
    lazy var recipeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .purple
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
//    func addRecipeView() {
//        historyFavCell?.displayRecipeView(recipeCell: self)
//    }
}
