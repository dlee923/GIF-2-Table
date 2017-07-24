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
        self.textColor = globalDetailCardLblColor
        return self
    }
}

class MainFeatureCell: StockMDCCell {
    
    override func setUpCell() {
        setUpCollectionView()
    }
    
    var recipes: [RecipeObject]? {
        didSet {
            if let featureRecipes = self.recipes?.sorted(by: { (recipe1, recipe2) -> Bool in
                return recipe1.likes! > recipe2.likes!
            }) {
                featureCollection.recipes = Array(featureRecipes.prefix(3))
            }            
            guard let featureCV = featureCollection.collectionView else { return }
            featureCV.reloadData()
        }
    }
    
    var mainVC: MainVC? {
        didSet {
            featureCollection.mainVC = self.mainVC
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
//        self.backgroundColor = .white
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
        setUpCardView()
        setUpCardDetailView()
    }
    
    var recipe: RecipeObject? {
        didSet {
            
            if let downloadedImg = recipe?.downloadedImage {
                self.fadeInImage(recipe: self.recipe!, recipeImage: self.recipeImage, downloadedImage: downloadedImg)
            } else {
                recipe?.downloadCoverImage(completion: { (coverImage, sameTitle) in
                    if self.recipe?.recipeTitle == sameTitle {
                        self.fadeInImage(recipe: self.recipe!, recipeImage: self.recipeImage, downloadedImage: coverImage)
                    }
                })
            }
            
            titleLabel.text = recipe?.recipeTitle
            categoryLabel.text = recipe?.category
            if let count = recipe?.recipeIngredients?.count {
                ingredientsLabel.text = "\(count) Ingredients"
            }
            difficultyLabel.text = recipe?.difficulty?.rawValue
            
            likeCountLabel.text = "\(recipe?.likes ?? 0)"
            dislikeCountLabel.text = "\(recipe?.dislikes ?? 0)"
            
            thumbsUp.recipeObj = self.recipe
            thumbsDown.recipeObj = self.recipe
            loveButton.recipeObj = self.recipe
        }
    }
    
    let recipeImgHeight: CGFloat = 0.65
    let labelLeadSpace: CGFloat = 6
    var recipeCardFrame: CGRect? {
        didSet {
            setUpLoveButton()
        }
    }
    var mainVC: MainVC? {
        didSet {
            thumbsUp.mainViewController = self.mainVC
            thumbsDown.mainViewController = self.mainVC
            loveButton.mainViewController = self.mainVC
            
            thumbsUp.opposingButton = self.thumbsDown
            thumbsDown.opposingButton = self.thumbsUp                        
        }
    }
    
    let recipeImage: UIImageView = {
        let _recipeImage = UIImageView()
        _recipeImage.contentMode = .scaleAspectFit
        _recipeImage.tintColor = tintedBlackLight.withAlphaComponent(0.5)
        _recipeImage.image = UIImage(named: "g2tplaceholder")?.withRenderingMode(.alwaysTemplate)
        _recipeImage.clipsToBounds = true
        _recipeImage.translatesAutoresizingMaskIntoConstraints = false
        return _recipeImage
    }()
    
    let detailView: UIView = {
        let _detailView = UIView()
        _detailView.backgroundColor = globalDetailCardColor
        _detailView.translatesAutoresizingMaskIntoConstraints = false
        return _detailView
    }()
    
    let categoryLabel = UILabel().recipeCardDetailLabel
    
    let titleLabel: UILabel = {
        let _titleLabel = UILabel()
        _titleLabel.font = fontReno?.withSize(12)
        _titleLabel.textColor = UIColor(white: 0, alpha: 0.9)
        return _titleLabel
    }()
    
    let ingredientsLabel = UILabel().recipeCardDetailLabel
    let difficultyLabel = UILabel().recipeCardDetailLabel
    
    let likeCountLabel: UILabel = {
        let _likeCountLabel = UILabel().recipeCardDetailLabel
        _likeCountLabel.textAlignment = .right
        return _likeCountLabel
    }()
    
    let dislikeCountLabel: UILabel = {
        let _likeCountLabel = UILabel().recipeCardDetailLabel
        _likeCountLabel.textAlignment = .right
        return _likeCountLabel
    }()
    
    lazy var thumbsUp: RecipeButton = {
        let _thumbsUp = RecipeButton()
        let image = UIImage(named: "ic_thumb_up")?.withRenderingMode(.alwaysTemplate)
        _thumbsUp.setImage(image, for: .normal)        
        _thumbsUp.listedView = self
        _thumbsUp.addLikeFunction(isThumbsUp: true)
        return _thumbsUp
    }()
    
    lazy var thumbsDown: RecipeButton = {
        let _thumbsDown = RecipeButton()
        let image = UIImage(named: "ic_thumb_down")?.withRenderingMode(.alwaysTemplate)
        _thumbsDown.setImage(image, for: .normal)
        _thumbsDown.listedView = self
        _thumbsDown.addLikeFunction(isThumbsUp: false)
        return _thumbsDown
    }()
    
    lazy var loveButton: RecipeButton = {
        let _loveButton = RecipeButton()
        _loveButton.backgroundColor = globalDetailCardColor
        let image = UIImage(named: "ic_favorite")?.withRenderingMode(.alwaysTemplate)
        _loveButton.setImage(image, for: .normal)
        _loveButton.addFavoriteFunction()
        return _loveButton
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
        detailView.addSubview(thumbsUp)
        detailView.addSubview(thumbsDown)
        detailView.addSubview(likeCountLabel)
        detailView.addSubview(dislikeCountLabel)
        
        for view in detailView.subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        categoryLabel.topAnchor.constraint(equalTo: detailView.topAnchor, constant: labelLeadSpace).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: labelLeadSpace).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor).isActive = true
        categoryLabel.heightAnchor.constraint(equalTo: detailView.heightAnchor, multiplier: 0.28).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: labelLeadSpace).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: detailView.heightAnchor, multiplier: 0.27).isActive = true
        
        difficultyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        difficultyLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: labelLeadSpace).isActive = true
        difficultyLabel.widthAnchor.constraint(equalTo: detailView.widthAnchor, multiplier: 0.2).isActive = true
        difficultyLabel.bottomAnchor.constraint(equalTo: detailView.bottomAnchor).isActive = true
        
        ingredientsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        ingredientsLabel.leadingAnchor.constraint(equalTo: difficultyLabel.trailingAnchor).isActive = true
        ingredientsLabel.widthAnchor.constraint(equalTo: detailView.widthAnchor, multiplier: 0.4).isActive = true
        ingredientsLabel.bottomAnchor.constraint(equalTo: detailView.bottomAnchor).isActive = true
        
        likeCountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        likeCountLabel.leadingAnchor.constraint(equalTo: ingredientsLabel.trailingAnchor).isActive = true
        likeCountLabel.widthAnchor.constraint(equalTo: detailView.widthAnchor, multiplier: 0.07).isActive = true
        likeCountLabel.bottomAnchor.constraint(equalTo: detailView.bottomAnchor).isActive = true
        
        thumbsUp.topAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        thumbsUp.leadingAnchor.constraint(equalTo: likeCountLabel.trailingAnchor).isActive = true
        thumbsUp.widthAnchor.constraint(equalTo: detailView.widthAnchor, multiplier: 0.125).isActive = true
        thumbsUp.bottomAnchor.constraint(equalTo: detailView.bottomAnchor, constant: -labelLeadSpace/2.5).isActive = true
        
        dislikeCountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        dislikeCountLabel.leadingAnchor.constraint(equalTo: thumbsUp.trailingAnchor).isActive = true
        dislikeCountLabel.widthAnchor.constraint(equalTo: detailView.widthAnchor, multiplier: 0.07).isActive = true
        dislikeCountLabel.bottomAnchor.constraint(equalTo: detailView.bottomAnchor).isActive = true
        
        thumbsDown.topAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        thumbsDown.leadingAnchor.constraint(equalTo: dislikeCountLabel.trailingAnchor).isActive = true
        thumbsDown.trailingAnchor.constraint(equalTo: detailView.trailingAnchor).isActive = true
        thumbsDown.bottomAnchor.constraint(equalTo: detailView.bottomAnchor, constant: -labelLeadSpace/2.5).isActive = true
    }
    
    func setUpLoveButton() {
        self.addSubview(loveButton)

        if let recipeFrame = recipeCardFrame {
            loveButton.heightAnchor.constraint(equalToConstant: recipeFrame.height * 0.2).isActive = true
            loveButton.widthAnchor.constraint(equalToConstant: recipeFrame.height * 0.2).isActive = true
            loveButton.layer.cornerRadius = (recipeFrame.height * 0.2) / 2
        }
        loveButton.centerYAnchor.constraint(equalTo: recipeImage.bottomAnchor).isActive = true
        loveButton.trailingAnchor.constraint(equalTo: recipeImage.trailingAnchor, constant: -8).isActive = true
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
        _headerLabel.font = fontPorter?.withSize(13)
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
    
    func fadeInImage(recipe: RecipeObject, recipeImage: UIImageView, downloadedImage: UIImage) {
        if recipe.shouldfade == true {
            UIView.animate(withDuration: 0.25, animations: {
                recipeImage.alpha = 0
            }, completion: { (_) in
                recipeImage.contentMode = .scaleAspectFill
                recipeImage.image = downloadedImage
                
                UIView.animate(withDuration: 0.25, animations: {
                    recipeImage.alpha = 1
                })
            })
            recipe.shouldfade = false
        } else {
            recipeImage.contentMode = .scaleAspectFill
            recipeImage.image = downloadedImage
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
