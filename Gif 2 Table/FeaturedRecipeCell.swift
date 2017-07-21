//
//  FeaturedRecipeCell.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 7/15/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialCollectionCells

class FeaturedRecipeCell: StockMDCCell {
    
    override func setUpCell() {
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        setUpView()
    }
    
    var recipe: RecipeObject? {
        didSet {
            recipe?.downloadCoverImage(completion: { (coverImage) in
                self.fadeInImage(recipe: self.recipe!, recipeImage: self.recipeImage, downloadedImage: coverImage)
            })
        }
    }
    
    let recipeImage: UIImageView = {
        let _recipeImage = UIImageView()
        _recipeImage.contentMode = .scaleAspectFit
        _recipeImage.tintColor = tintedBlack.withAlphaComponent(0.5)
        _recipeImage.image = UIImage(named: "g2tplaceholder")?.withRenderingMode(.alwaysTemplate)
        _recipeImage.clipsToBounds = true
        _recipeImage.translatesAutoresizingMaskIntoConstraints = false
        return _recipeImage
    }()
    
    func setUpView() {
        self.addSubview(recipeImage)
        recipeImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        recipeImage.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        recipeImage.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        recipeImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
}
