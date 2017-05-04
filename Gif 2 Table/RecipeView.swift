//
//  RecipeView.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 4/21/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class RecipeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setUpRecipeView()
        addPlayButton(viewToAddTo: self)
        
        print("instantiated")
    }
    
    var recipe: RecipeObject? {
        didSet {
            //when set, call load ingredients list
            recipeTitle.text = recipe?.recipeTitle
            ingredientsView.recipe = self.recipe
            loadRecipeImage()
        }
    }
    
    func loadRecipeImage() {
        recipe?.downloadCoverImage(completion: { (coverImage) in
            self.recipeImage.image = coverImage
        })        
    }
    
    var mainViewController: MainVC? {
        didSet {
            addIngredientListView(viewAddedTo: self)
        }
    }
    
    let recipeTitle: UILabel = {
        let label = UILabel()
        label.font = fontMessy?.withSize(20)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.text = "Generic Recipe Title"
        return label
    }()
    
    let recipeImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .white
        image.layer.cornerRadius = 10
        return image
    }()
    
    let recipeImageShadow: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowOpacity = 0.5
        return view
    }()
    
    lazy var playButton: PlayButton = {
        let button = PlayButton()
        button.recipeView = self
        return button
    }()
    
    let saveFavoritesView: SaveFavoritesView = {
        let view = SaveFavoritesView()
        return view
    }()
    
    lazy var ingredientsView: IngredientsView = {
        let view = IngredientsView()
        view.recipeView = self
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()    
    
    var ingredientsViewSizeMultHeight: CGFloat = 0.85
    var ingredientsViewSizeMultWidth: CGFloat = 0.9
    
    fileprivate func setUpRecipeView() {
        
        self.addSubview(recipeTitle)
        self.addSubview(recipeImageShadow)
        recipeImageShadow.addSubview(recipeImage)
        self.addSubview(saveFavoritesView)
        
        self.addConstraintsWithFormat(format: "H:|-[v0]-|", views: recipeTitle)
        self.addConstraintsWithFormat(format: "H:|-[v0]-|", views: recipeImageShadow)
        self.addConstraintsWithFormat(format: "H:|-[v0]-|", views: saveFavoritesView)
        
        self.addConstraintsWithFormat(format: "V:|-[v0(40)]-8-[v1]-6-[v2(75)]-86-|", views: recipeTitle, recipeImageShadow, saveFavoritesView)
        
        recipeImageShadow.addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: recipeImage)
        recipeImageShadow.addConstraintsWithFormat(format: "V:|-4-[v0]-4-|", views: recipeImage)
    }
    
    var ingredientsViewCenterY: NSLayoutConstraint?
    var yConstantStartPosition: CGFloat?
    var yConstantMaxPosition: CGFloat = 0
    
    func addIngredientListView(viewAddedTo: UIView) {
        viewAddedTo.addSubview(ingredientsView)
        ingredientsView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: ingredientsViewSizeMultHeight).isActive = true
        ingredientsView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: ingredientsViewSizeMultWidth).isActive = true
        ingredientsView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        
        if self.frame.height != 0 {
            // capture frame height
            yConstantStartPosition = (self.frame.height * ingredientsViewSizeMultHeight)/2 + (self.frame.height/2) - 68
            yConstantMaxPosition = (self.frame.height * (1-ingredientsViewSizeMultHeight))/2
            
        } else if let recipeViewFrameHeight = self.superview?.frame.height {
            // capture superview frame height
            yConstantStartPosition = (recipeViewFrameHeight * ingredientsViewSizeMultHeight)/2 + (recipeViewFrameHeight/2) - 68
            yConstantMaxPosition = (recipeViewFrameHeight * (1-ingredientsViewSizeMultHeight))/2
            
        }
        if let startPosition = yConstantStartPosition {
            ingredientsViewCenterY = ingredientsView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: startPosition)
            ingredientsViewCenterY?.isActive = true
        }        
    }
    
    func addPlayButton(viewToAddTo: UIView) {
        viewToAddTo.addSubview(playButton)
        
        playButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        playButton.centerXAnchor.constraint(equalTo: recipeImage.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: recipeImage.centerYAnchor).isActive = true
    }
    
    func playRecipe() {
        print("Play Recipe")
//        playButton.removeFromSuperview()
        //animate button to morph, then add the view to be presented.
        
        let videoPlayer = PlayVideo()
        videoPlayer.mainViewController = self.mainViewController
        guard let link = self.recipe?.recipeLink else { return }
        
        videoPlayer.playVideo(videoURL: link)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
