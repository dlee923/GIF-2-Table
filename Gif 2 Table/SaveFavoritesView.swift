//
//  SaveFavoritesView.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 5/2/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class SaveFavoritesView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    let likeDislikeFontSize: CGFloat = 12
    let happyColor = UIColor.green
    let sadColor = UIColor.red
    let defaultColor = UIColor(red: 197/255, green: 199/255, blue: 143/255, alpha: 1)
    let heartColor = UIColor.red
    let pressedSize: CGFloat = 1.3
    let diceColor = UIColor(red: 197/255, green: 199/255, blue: 143/255, alpha: 1)
    let resetColor = UIColor(red: 197/255, green: 199/255, blue: 143/255, alpha: 1)
    
    let coreDataManager = CoreDataManager()
    let firebaseManager = Firebase()
    
    var mainViewController: MainVC?
    var recipeObj: RecipeObject? {
        didSet {
            print("recipe set")
            checkIfFavorite()
            
            happyFace.isSelected = (recipeObj?.isLiked)!
            happyText.text = "\((recipeObj?.likes)!)"
            
            sadFace.isSelected = (recipeObj?.isDisliked)!
            sadText.text = "\((recipeObj?.dislikes)!)"
            
            checkIfLiked()
            
            setHappyFaceColors()
            setSadFaceColors()
        }
    }
    
    func checkIfFavorite() {
        let favoriteIndex = self.mainViewController?.favoriteRecipes.index(where: { (recipe) -> Bool in
            recipe.recipeTitle == self.recipeObj?.recipeTitle
        })
        
        if favoriteIndex != nil {
            print("favorite exists \(favoriteIndex ?? 0)")
            favoriteBtn.isSelected = true
            favoriteBtn.tintColor = favoriteBtn.isSelected ? heartColor : defaultColor
        }
    }
    
    func checkIfLiked() {
        let likedIndex = self.mainViewController?.likedRecipes.index(where: { (recipe) -> Bool in
            recipe.recipeTitle == self.recipeObj?.recipeTitle
        })
        
        if likedIndex != nil {
            print("liked exists \(likedIndex ?? 0)")
            happyFace.isSelected = true
            sadFace.isSelected = false
        }
        
        let dislikedIndex = self.mainViewController?.dislikedRecipes.index(where: { (recipe) -> Bool in
            recipe.recipeTitle == self.recipeObj?.recipeTitle
        })
        
        if dislikedIndex != nil {
            print("dislike exists \(dislikedIndex ?? 0)")
            happyFace.isSelected = false
            sadFace.isSelected = true
        }
    }
    
    func setUpView() {
        self.backgroundColor = .clear
        self.addSubview(happyFace)
        self.addSubview(sadFace)
        self.addSubview(happyText)
        self.addSubview(sadText)
        self.addSubview(favoriteBtn)
        self.addSubview(randomizeBtn)
        self.addSubview(resetBtn)
        self.addSubview(favoriteText)
        self.addSubview(randomizeText)
        self.addSubview(resetText)
        self.addSubview(likeText)
        self.addSubview(dislikeText)
        
        
        addConstraintsWithFormat(format: "H:|[v0]", views: favoriteBtn)
        randomizeBtn.leadingAnchor.constraint(equalTo: favoriteBtn.trailingAnchor, constant: -(18.75/375)*UIScreen.main.bounds.width).isActive = true
        resetBtn.leadingAnchor.constraint(equalTo: randomizeBtn.trailingAnchor, constant: -(18.75/375)*UIScreen.main.bounds.width).isActive = true
        happyFace.leadingAnchor.constraint(equalTo: resetBtn.trailingAnchor, constant: -(18.75/375)*UIScreen.main.bounds.width).isActive = true
        sadFace.leadingAnchor.constraint(equalTo: happyFace.trailingAnchor, constant: -(18.75/375)*UIScreen.main.bounds.width).isActive = true
        
        addConstraintsWithFormat(format: "V:[v0(11)]-2-|", views: sadText)
        addConstraintsWithFormat(format: "V:[v0(10)]-2-|", views: happyText)
        addConstraintsWithFormat(format: "V:|-[v0]|", views: sadFace)
        addConstraintsWithFormat(format: "V:|-[v0]|", views: happyFace)
        addConstraintsWithFormat(format: "V:|-[v0]|", views: favoriteBtn)
        addConstraintsWithFormat(format: "V:|-[v0]|", views: randomizeBtn)
        addConstraintsWithFormat(format: "V:|-[v0]|", views: resetBtn)
        
        addConstraintsWithFormat(format: "V:|-10-[v0(10)]", views: favoriteText)
        addConstraintsWithFormat(format: "V:|-10-[v0(10)]", views: randomizeText)
        addConstraintsWithFormat(format: "V:|-10-[v0(10)]", views: resetText)
        addConstraintsWithFormat(format: "V:|-10-[v0(10)]", views: likeText)
        addConstraintsWithFormat(format: "V:|-10-[v0(10)]", views: dislikeText)
        
        //width anchors
        sadFace.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 90/375).isActive = true
        happyFace.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 90/375).isActive = true
        favoriteBtn.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 90/375).isActive = true
        randomizeBtn.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 90/375).isActive = true
        resetBtn.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 90/375).isActive = true
        
        sadText.centerXAnchor.constraint(equalTo: sadFace.centerXAnchor, constant: 7).isActive = true
        sadText.widthAnchor.constraint(equalTo: sadFace.widthAnchor, constant: 0).isActive = true
        happyText.centerXAnchor.constraint(equalTo: happyFace.centerXAnchor, constant: 7).isActive = true
        happyText.widthAnchor.constraint(equalTo: happyFace.widthAnchor, constant: 0).isActive = true
        
        let titleOffset: CGFloat = 0
        let titleWidth: CGFloat = 0.78
        
        favoriteText.leadingAnchor.constraint(equalTo: favoriteBtn.leadingAnchor, constant: titleOffset).isActive = true
        favoriteText.widthAnchor.constraint(equalTo: favoriteBtn.widthAnchor, multiplier: titleWidth).isActive = true
        
        randomizeText.leadingAnchor.constraint(equalTo: randomizeBtn.leadingAnchor, constant: titleOffset).isActive = true
        randomizeText.widthAnchor.constraint(equalTo: randomizeBtn.widthAnchor, multiplier: titleWidth).isActive = true
        
        resetText.leadingAnchor.constraint(equalTo: resetBtn.leadingAnchor, constant: titleOffset).isActive = true
        resetText.widthAnchor.constraint(equalTo: resetBtn.widthAnchor, multiplier: titleWidth).isActive = true
        
        likeText.leadingAnchor.constraint(equalTo: happyFace.leadingAnchor, constant: titleOffset).isActive = true
        likeText.widthAnchor.constraint(equalTo: happyFace.widthAnchor, multiplier: titleWidth).isActive = true
        
        dislikeText.leadingAnchor.constraint(equalTo: sadFace.leadingAnchor, constant: titleOffset).isActive = true
        dislikeText.widthAnchor.constraint(equalTo: sadFace.widthAnchor, multiplier: titleWidth).isActive = true
        
        

//        sadFace.tintColor = sadFace.isSelected ? self.sadColor : self.defaultColor
    }

    var face2 = {(happySad: String, color: UIColor) -> SaveFavButton in
        let face = SaveFavButton(type: UIButtonType.custom)
        face.imageEdgeInsets = UIEdgeInsetsMake(16, 16, 16, 16)
        face.setImage(UIImage(named: happySad)!.withRenderingMode(.alwaysTemplate), for: .normal)
        face.imageView?.contentMode = .scaleAspectFit
        face.tintColor = color
        return face
    }
    
    lazy var favoriteBtn: SaveFavButton = {
        let heart = self.face2("heart", self.defaultColor)
        heart.addTarget(self, action: #selector(self.favoriteBtnPressed), for: .touchUpInside)
        return heart
    }()
    
    lazy var happyFace: SaveFavButton = {
        let face = self.face2("happy", self.defaultColor)
        face.addTarget(self, action: #selector(self.happyBtnPressed), for: .touchUpInside)
        return face
    }()
    
    lazy var sadFace: SaveFavButton = {
        let face = self.face2("sad", self.defaultColor)
        face.addTarget(self, action: #selector(self.sadBtnPressed), for: .touchUpInside)
        return face
    }()
    
    lazy var happyText: UILabel = {
        let text = UILabel()
        text.text = "0"
        text.font = fontHello?.withSize(self.likeDislikeFontSize)
        text.textAlignment = .center
        return text
    }()
    
    lazy var sadText: UILabel = {
        let text = UILabel()
        text.text = "0"
        text.font = fontHello?.withSize(self.likeDislikeFontSize)
        text.textAlignment = .center
        return text
    }()
    
    let favoriteText: UILabel = {
        let text = UILabel()
        text.setButtonTitles()
        text.text = "Favorite"
        return text
    }()
    
    let randomizeText: UILabel = {
        let text = UILabel()
        text.setButtonTitles()
        text.text = "Randomize"
        return text
    }()
    
    let resetText: UILabel = {
        let text = UILabel()
        text.setButtonTitles()
        text.text = "Reset"
        return text
    }()
    
    let likeText: UILabel = {
        let text = UILabel()
        text.setButtonTitles()
        text.text = "Like"
        return text
    }()
    
    let dislikeText: UILabel = {
        let text = UILabel()
        text.setButtonTitles()
        text.text = "Dislike"
        return text
    }()
    
    lazy var randomizeBtn: SaveFavButton = {
        let dice = self.face2("dice1", self.diceColor)
        dice.addTarget(self, action: #selector(self.randomize), for: .touchUpInside)
        return dice
    }()
    
    lazy var resetBtn: SaveFavButton = {
        let reset = self.face2("reset2", self.resetColor)
        reset.addTarget(self, action: #selector(self.reset), for: .touchUpInside)
        return reset
    }()
    
    func pressedAnimation(object: UIButton, needsReload: Bool) {
        let animationDistance: CGFloat = 30
        
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
            object.transform = CGAffineTransform(translationX: -(((animationDistance / object.frame.height) * object.frame.width) * 0.25), y: -animationDistance)
        }) { (_) in
            UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
                object.layer.transform = CATransform3DIdentity
            }, completion: { (_) in
                if needsReload {
                    self.mainViewController?.collectionView?.reloadData()
                } else {
                    // do nothing
                }
            })
        }
        
        if object.isSelected == false {
            object.isSelected = true
        } else {
            object.isSelected = false
        }
    }
    
    func pressedAnimationText(object: UIView) {
        let animationDistance: CGFloat = 30
        UIView.animate(withDuration: 0.2, animations: {
            object.transform = CGAffineTransform(translationX: -(((object.frame.height / animationDistance) * object.frame.width) * 0.25), y: -animationDistance)
            
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                object.layer.transform = CATransform3DIdentity
            }, completion: { (_) in
                
            })
        }
        
        print((((animationDistance / object.frame.height) * object.frame.width) * 0.25))
        print(object.frame.height)
        print(object.frame.width)
    }
    
    func setHappyFaceColors() {
        happyFace.tintColor = happyFace.isSelected ? self.happyColor : self.defaultColor
        happyText.textColor = happyFace.isSelected ? self.happyColor : self.defaultColor
    }
    
    func setSadFaceColors() {
        sadFace.tintColor = sadFace.isSelected ? self.sadColor : self.defaultColor
        sadText.textColor = sadFace.isSelected ? self.sadColor : self.defaultColor
    }

    var previousRandomNumber: Int?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
