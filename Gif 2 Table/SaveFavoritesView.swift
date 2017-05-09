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
    let heartColor = UIColor.black
    let heartColorFilled = UIColor.red
    let pressedSize: CGFloat = 1.3
    let diceColor = UIColor.black
    let resetColor = UIColor.black
    
    func setUpView() {
        self.backgroundColor = .clear
        self.addSubview(happyFace)
        self.addSubview(sadFace)
        self.addSubview(happyText)
        self.addSubview(sadText)
        self.addSubview(favoriteBtn)
        self.addSubview(randomizeBtn)
        self.addSubview(resetBtn)
        
        addConstraintsWithFormat(format: "H:[v1(50)]-[v0(50)]|", views: sadFace, happyFace)
        addConstraintsWithFormat(format: "H:|[v0(90)]", views: favoriteBtn)
        addConstraintsWithFormat(format: "H:|-70-[v0(90)]", views: randomizeBtn)
        addConstraintsWithFormat(format: "H:|-140-[v0(90)]", views: resetBtn)
        
        addConstraintsWithFormat(format: "V:|[v0]-4-[v1(10)]-5-|", views: sadFace, sadText)
        happyFace.heightAnchor.constraint(equalTo: sadFace.heightAnchor, multiplier: 1).isActive = true
        addConstraintsWithFormat(format: "V:|-15-[v0]-4-[v1(10)]", views: happyFace, happyText)

        addConstraintsWithFormat(format: "V:|-[v0]|", views: favoriteBtn)
        addConstraintsWithFormat(format: "V:|-[v0]|", views: randomizeBtn)
        addConstraintsWithFormat(format: "V:|-[v0]|", views: resetBtn)
        
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
    
    func pressedAnimation(object: UIButton) {
        let animationAngle: CGFloat = 30
        UIView.animate(withDuration: 0.2, animations: {
            object.transform = CGAffineTransform(translationX: -(((animationAngle / object.frame.height) * object.frame.width) * 0.25), y: -animationAngle)
            
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                object.layer.transform = CATransform3DIdentity
            })
        }
        
        if object.isSelected == false {
            object.isSelected = true
        } else {
            object.isSelected = false
        }
    }
    
    func favoriteBtnPressed(){
        print("btn pressed")
        pressedAnimation(object: favoriteBtn)
        favoriteBtn.tintColor = favoriteBtn.isSelected ? UIColor.red : UIColor.black
        let favMessage = favoriteBtn.isSelected ? "I love this!  Adding to my favorites!" : "Blegh!! I got tired of this!"
        let promptView = PromptView()
        promptView.setUpPrompt(heightPct: 0.2, widthPct: 0.9, promptMsg: favMessage, messageLines: 1, messageOnly: true, doesDisappear: true)
    }
    
    func happyBtnPressed() {
        print("Happy face")
        pressedAnimation(object: happyFace)

        happyFace.tintColor = happyFace.isSelected ? self.happyColor : self.defaultColor
        happyText.textColor = happyFace.isSelected ? self.happyColor : self.defaultColor
    }
    
    func sadBtnPressed() {
        print("Sad face")
        pressedAnimation(object: sadFace)
        
        sadFace.tintColor = sadFace.isSelected ? self.sadColor : self.defaultColor
        sadText.textColor = sadFace.isSelected ? self.sadColor : self.defaultColor
    }
    
    func randomize() {
        print("Randomize")
        pressedAnimation(object: randomizeBtn)
    }
    
    func reset() {
        print("Reset")
        pressedAnimation(object: resetBtn)
        
        let promptView = PromptView()
        promptView.setUpPrompt(heightPct: 0.2, widthPct: 0.9, promptMsg: "Reset to latest feature recipe?", messageLines: 2, messageOnly: false, doesDisappear: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
