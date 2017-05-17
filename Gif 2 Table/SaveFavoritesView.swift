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
    let defaultColor = UIColor.black
    let heartColor = UIColor.red
    let pressedSize: CGFloat = 1.3
    let diceColor = UIColor.black
    let resetColor = UIColor.black
    
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
        
        addConstraintsWithFormat(format: "H:[v1]-[v0]|", views: sadFace, happyFace)
        addConstraintsWithFormat(format: "H:|[v0]", views: favoriteBtn)
        randomizeBtn.leadingAnchor.constraint(equalTo: favoriteBtn.trailingAnchor, constant: -(15/375)*UIScreen.main.bounds.width).isActive = true
        resetBtn.leadingAnchor.constraint(equalTo: randomizeBtn.trailingAnchor, constant: -(15/375)*UIScreen.main.bounds.width).isActive = true
        
        addConstraintsWithFormat(format: "V:|[v0]-4-[v1(10)]-5-|", views: sadFace, sadText)
        happyFace.heightAnchor.constraint(equalTo: sadFace.heightAnchor, multiplier: 1).isActive = true
        addConstraintsWithFormat(format: "V:|-15-[v0]-4-[v1(10)]", views: happyFace, happyText)

        addConstraintsWithFormat(format: "V:|-[v0]|", views: favoriteBtn)
        addConstraintsWithFormat(format: "V:|-[v0]|", views: randomizeBtn)
        addConstraintsWithFormat(format: "V:|-[v0]|", views: resetBtn)
        
        //width anchors
        sadFace.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 50/375).isActive = true
        happyFace.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 50/375).isActive = true
        favoriteBtn.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 90/375).isActive = true
        randomizeBtn.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 90/375).isActive = true
        resetBtn.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 90/375).isActive = true
        
        sadText.centerXAnchor.constraint(equalTo: sadFace.centerXAnchor, constant: 0).isActive = true
        sadText.widthAnchor.constraint(equalTo: sadFace.widthAnchor, constant: 0).isActive = true
        happyText.centerXAnchor.constraint(equalTo: happyFace.centerXAnchor, constant: 0).isActive = true
        happyText.widthAnchor.constraint(equalTo: happyFace.widthAnchor, constant: 0).isActive = true

        sadFace.tintColor = sadFace.isSelected ? self.sadColor : self.defaultColor
    }
    
    var face = {(happySad: String, color: UIColor) -> UIButton in
        let face = UIButton(type: UIButtonType.custom)
        face.setImage(UIImage(named: happySad)!.withRenderingMode(.alwaysTemplate), for: .normal)
        face.imageView?.contentMode = .scaleAspectFit
        face.tintColor = color
        return face
    }
    
    var face2 = {(happySad: String, color: UIColor) -> SaveFavButton in
        let face = SaveFavButton(type: UIButtonType.custom)
        face.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
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
    
    lazy var happyFace: UIButton = {
        let face = self.face("happy", self.defaultColor)
        face.addTarget(self, action: #selector(self.happyBtnPressed), for: .touchUpInside)
        return face
    }()
    
    lazy var sadFace: UIButton = {
        let face = self.face("sad", self.defaultColor)
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
        UIView.animate(withDuration: 0.2, animations: {
            object.transform = CGAffineTransform(translationX: -(((animationDistance / object.frame.height) * object.frame.width) * 0.25), y: -animationDistance)
            
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
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
    
    func removeFromFavorites() {
        let favIndex = self.mainViewController?.favoriteRecipes.index(where: { (recipe) -> Bool in
            recipe.recipeTitle == self.recipeObj?.recipeTitle
        })
        
        print("this recipe was located on the favorite array at index: \(favIndex ?? 0)")
        
        if let titleToRemove = self.mainViewController?.favoriteRecipes[favIndex!].recipeTitle {
            coreDataManager.deleteData(recipeTitle: titleToRemove, entityName: "RecipeModel")
        }
        
        self.mainViewController?.favoriteRecipes.remove(at: favIndex!)
    }
    
    func favoriteBtnPressed(){
        print("btn pressed")
        pressedAnimation(object: favoriteBtn, needsReload: true)
        
        if favoriteBtn.isSelected {
            print("adding to favorites")
            self.recipeObj?.favorite = true
            if let object = self.recipeObj {
                self.mainViewController?.favoriteRecipes.append(object)
                coreDataManager.saveData(recipe: object, recipeModel: true, recipeLike: false, recipeDislike: false)
            }            
        } else {
            print("removing from favorites")
            self.recipeObj?.favorite = false
            removeFromFavorites()
        }
        
        favoriteBtn.tintColor = favoriteBtn.isSelected ? heartColor : defaultColor
        let favMessage = favoriteBtn.isSelected ? "I love this!  Adding to my favorites!" : "Blegh!! I got tired of this!"
        let promptView = PromptView()
        promptView.setUpPrompt(objectCalling: favoriteBtn, heightPct: 0.2, widthPct: 0.9, promptMsg: favMessage, messageLines: 1, messageOnly: true, doesDisappear: true)
    }
    
    func happyBtnPressed() {
        print("Happy face")
        var count = Int(happyText.text!)
        pressedAnimation(object: happyFace, needsReload: false)
        self.recipeObj?.isLiked = true
        self.recipeObj?.isDisliked = false
        setHappyFaceColors()
        if let object = self.recipeObj {
            if happyFace.isSelected {
                // increase count + push to server
                count! += 1
                happyText.text = "\(count!)"
                recipeObj?.likes = count!
                firebaseManager.pushLikeDislikeValue(recipe: self.recipeObj!)
                
                self.mainViewController?.likedRecipes.append(object)
                coreDataManager.saveData(recipe: object, recipeModel: false, recipeLike: true, recipeDislike: false)
            } else if happyFace.isSelected == false {
                //decrease count + push to server
                count! -= 1
                happyText.text = "\(count!)"
                recipeObj?.likes = count!
                firebaseManager.pushLikeDislikeValue(recipe: self.recipeObj!)
                
                let likedIndex = self.mainViewController?.likedRecipes.index(where: { (recipe) -> Bool in
                    recipe.recipeTitle == self.recipeObj?.recipeTitle
                })
                if likedIndex != nil {
                    self.mainViewController?.likedRecipes.remove(at: likedIndex!)
                    coreDataManager.deleteData(recipeTitle: (self.recipeObj?.recipeTitle)!, entityName: "LikedRecipe")
                }
            }
        }
        
        if sadFace.isSelected {
            sadFace.isSelected = false
            setSadFaceColors()
            let dislikedIndex = self.mainViewController?.dislikedRecipes.index(where: { (recipe) -> Bool in
                recipe.recipeTitle == self.recipeObj?.recipeTitle
            })
            print("dislikeIndex: \(dislikedIndex)")
            if dislikedIndex != nil {
                self.mainViewController?.dislikedRecipes.remove(at: dislikedIndex!)
                coreDataManager.deleteData(recipeTitle: (self.recipeObj?.recipeTitle)!, entityName: "DislikedRecipe")
                //decrease count + push to server
                var count2 = Int(sadText.text!)
                count2! -= 1
                sadText.text = "\(count2!)"
                recipeObj?.dislikes = count!
                firebaseManager.pushLikeDislikeValue(recipe: self.recipeObj!)
            }
        }
    }
    
    func setHappyFaceColors() {
        happyFace.tintColor = happyFace.isSelected ? self.happyColor : self.defaultColor
        happyText.textColor = happyFace.isSelected ? self.happyColor : self.defaultColor
    }
    
    func sadBtnPressed() {
        print("Sad face")
        var count = Int(sadText.text!)
        pressedAnimation(object: sadFace, needsReload: false)
        self.recipeObj?.isDisliked = true
        self.recipeObj?.isLiked = false
        setSadFaceColors()
        
        if let object = self.recipeObj {
            if sadFace.isSelected {
                //increase count + push to server
                count! += 1
                sadText.text = "\(count!)"
                recipeObj?.dislikes = count!
                firebaseManager.pushLikeDislikeValue(recipe: self.recipeObj!)
                
                self.mainViewController?.dislikedRecipes.append(object)
                coreDataManager.saveData(recipe: object, recipeModel: false, recipeLike: false, recipeDislike: true)
            } else if sadFace.isSelected == false {
                //decrease count + push to server
                count! -= 1
                sadText.text = "\(count!)"
                recipeObj?.dislikes = count!
                firebaseManager.pushLikeDislikeValue(recipe: self.recipeObj!)
                
                let dislikedIndex = self.mainViewController?.dislikedRecipes.index(where: { (recipe) -> Bool in
                    recipe.recipeTitle == self.recipeObj?.recipeTitle
                })
                if dislikedIndex != nil {
                    self.mainViewController?.dislikedRecipes.remove(at: dislikedIndex!)
                    coreDataManager.deleteData(recipeTitle: (self.recipeObj?.recipeTitle)!, entityName: "DislikedRecipe")
                }
            }
        }
        
        if happyFace.isSelected {
            happyFace.isSelected = false
            setHappyFaceColors()
            let likedIndex = self.mainViewController?.likedRecipes.index(where: { (recipe) -> Bool in
                recipe.recipeTitle == self.recipeObj?.recipeTitle
            })
            print("likedIndex: \(likedIndex)")
            if likedIndex != nil {
                self.mainViewController?.likedRecipes.remove(at: likedIndex!)
                coreDataManager.deleteData(recipeTitle: (self.recipeObj?.recipeTitle)!, entityName: "LikedRecipe")
                //decrease count + push to server
                var count2 = Int(happyText.text!)
                count2! -= 1
                happyText.text = "\(count2!)"
                recipeObj?.likes = count!
                firebaseManager.pushLikeDislikeValue(recipe: self.recipeObj!)
            }
        }
    }
    
    func setSadFaceColors() {
        sadFace.tintColor = sadFace.isSelected ? self.sadColor : self.defaultColor
        sadText.textColor = sadFace.isSelected ? self.sadColor : self.defaultColor
    }
    
    func generateRandomNumber() -> Int {
        guard let upperLimit = mainViewController?.recipes.count else { return 0 }
        let randomNumber = Int(arc4random_uniform(UInt32(upperLimit)))
        print(randomNumber)
        return randomNumber
    }
    
    var previousRandomNumber: Int?
    
    func randomize() {
        print("Randomize")
        var randomNumber: Int?
        
        repeat { randomNumber = generateRandomNumber()
        } while previousRandomNumber == randomNumber
        previousRandomNumber = randomNumber
        
        if let randomRecipe = mainViewController?.recipes[randomNumber!] {
            mainViewController?.featureRecipe = randomRecipe
        }
        
        pressedAnimation(object: randomizeBtn, needsReload: true)
    }
    
    func reset() {
        print("Reset")
        pressedAnimation(object: resetBtn, needsReload: false)
        resetBtn.isUserInteractionEnabled = false
        let promptView = PromptView()
        promptView.mainViewController = self.mainViewController
        promptView.setUpPrompt(objectCalling: resetBtn, heightPct: 0.2, widthPct: 0.9, promptMsg: "Reset to the feature recipe?", messageLines: 2, messageOnly: false, doesDisappear: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
