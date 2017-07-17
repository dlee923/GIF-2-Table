//
//  MainRecipeCell.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 7/15/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialCollectionCells

extension UILabel {
    var recipeCardDetailLabel: UILabel {
        self.font = fontReno?.withSize(10)
        self.textColor = UIColor(white: 0, alpha: 0.5)
        return self
    }
}

class MainFeatureCell: StockMDCCell {
    
    override func setUpCell() {
        setUpCollectionView()
    }
    
    var recipes: [RecipeObject]? {
        didSet {
            featureCollection.recipes = self.recipes
            guard let featureCV = featureCollection.collectionView else { return }
            featureCV.reloadData()
        }
    }
    
    let featureCollection = FeaturedRecipesCV(collectionViewLayout: UICollectionViewFlowLayout())
    
    fileprivate func setUpCollectionView() {
        guard let featureCV = featureCollection.collectionView else { return }
        
        self.addSubview(featureCV)
        
        featureCV.translatesAutoresizingMaskIntoConstraints = false
        featureCV.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        featureCV.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        featureCV.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        featureCV.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}

class MainRecipeCell: StockMDCCell {
    
    override func setUpCell() {
        self.backgroundColor = .red
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
        setUpCardView()
        setUpCardDetailView()
    }
    
    var recipe: RecipeObject? {
        didSet {
            // assign cell attributes once set
            recipeImage.image = UIImage(named: "genericImage")
            recipe?.downloadCoverImage(completion: { (coverImage) in
                UIView.animate(withDuration: 0.25, animations: { 
                    self.recipeImage.image = coverImage
                })                
            })
            titleLabel.text = recipe?.recipeTitle
            categoryLabel.text = "\(recipe?.favorite)"
            ingredientsLabel.text = "\(recipe?.recipeIngredients?.count) Ingredients"
            difficultyLabel.text = recipe?.difficulty?.rawValue
        }
    }
    
    let recipeImgHeight: CGFloat = 0.65
    
    let recipeImage: UIImageView = {
        let _recipeImage = UIImageView()
        _recipeImage.contentMode = .scaleAspectFill
        _recipeImage.clipsToBounds = true
        _recipeImage.translatesAutoresizingMaskIntoConstraints = false
        return _recipeImage
    }()
    
    let detailView: UIView = {
        let _detailView = UIView()
        _detailView.backgroundColor = .white
        _detailView.translatesAutoresizingMaskIntoConstraints = false
        return _detailView
    }()
    
    let categoryLabel = UILabel().recipeCardDetailLabel
    let ingredientsLabel = UILabel().recipeCardDetailLabel
    let difficultyLabel = UILabel().recipeCardDetailLabel
    let titleLabel: UILabel = {
        let _titleLabel = UILabel()
        _titleLabel.font = fontGeo?.withSize(13)
        _titleLabel.textColor = UIColor(white: 0, alpha: 0.9)
        return _titleLabel
    }()
    
    fileprivate func setUpCardView() {
        self.addSubview(recipeImage)
        self.addSubview(detailView)
        
        recipeImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        recipeImage.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        recipeImage.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        recipeImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: recipeImgHeight).isActive = true
        
        detailView.topAnchor.constraint(equalTo: recipeImage.bottomAnchor).isActive = true
        detailView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        detailView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        detailView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    fileprivate func setUpCardDetailView() {
        detailView.addSubview(categoryLabel)
        detailView.addSubview(ingredientsLabel)
        detailView.addSubview(difficultyLabel)
        detailView.addSubview(titleLabel)
        
        for view in detailView.subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        categoryLabel.topAnchor.constraint(equalTo: detailView.topAnchor).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor).isActive = true
        categoryLabel.heightAnchor.constraint(equalTo: detailView.heightAnchor, multiplier: 0.3).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: detailView.heightAnchor, multiplier: 0.35).isActive = true
        
        difficultyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        difficultyLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor).isActive = true
        difficultyLabel.widthAnchor.constraint(equalTo: detailView.widthAnchor, multiplier: 0.5).isActive = true
        difficultyLabel.bottomAnchor.constraint(equalTo: detailView.bottomAnchor).isActive = true
        
        ingredientsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        ingredientsLabel.leadingAnchor.constraint(equalTo: difficultyLabel.trailingAnchor).isActive = true
        ingredientsLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor).isActive = true
        ingredientsLabel.bottomAnchor.constraint(equalTo: detailView.bottomAnchor).isActive = true
        
    }

}

class MainHeaderCell: StockMDCCell {
    
    override func setUpCell() {
        self.addSubview(headerLabel)
    }
    
    var collectionViewSideSpacing: CGFloat = 0 {
        didSet {
            setUpViewConstraints()
        }
    }
    
    fileprivate func setUpViewConstraints() {
        headerLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: collectionViewSideSpacing).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    let headerLabel: UILabel = {
        let _headerLabel = UILabel()
        _headerLabel.font = fontGeo?.withSize(13)
        _headerLabel.textColor = UIColor(white: 0, alpha: 0.9)
        _headerLabel.translatesAutoresizingMaskIntoConstraints = false
        return _headerLabel
    }()
}

class StockMDCCell: MDCCollectionViewCell {
    
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
