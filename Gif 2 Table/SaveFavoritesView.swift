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
    let happyColor = UIColor.black
    let sadColor = UIColor.black
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
        self.addSubview(favoriteActive)
        self.addSubview(favoriteBtn)
        self.addSubview(randomizeBtn)
        self.addSubview(resetBtn)
        favoriteActive.isHidden = true
        
        addConstraintsWithFormat(format: "H:[v1(70)][v0(70)]|", views: sadFace, happyFace)
        addConstraintsWithFormat(format: "H:[v1(70)][v0(70)]|", views: sadText, happyText)
        
        addConstraintsWithFormat(format: "V:|[v0]-4-[v1(10)]-5-|", views: sadFace, sadText)
        happyFace.heightAnchor.constraint(equalTo: sadFace.heightAnchor, multiplier: 1).isActive = true
        addConstraintsWithFormat(format: "V:|-15-[v0]-4-[v1(10)]", views: happyFace, happyText)
        
        addConstraintsWithFormat(format: "H:|[v0(75)]", views: favoriteActive)
        addConstraintsWithFormat(format: "V:|-[v0]|", views: favoriteActive)
        addConstraintsWithFormat(format: "H:|[v0(75)][v1(75)]", views: favoriteBtn, randomizeBtn)
        addConstraintsWithFormat(format: "V:|-[v0]|", views: favoriteBtn)
        
        addConstraintsWithFormat(format: "V:|-[v0]|", views: randomizeBtn)
        
    }
    
    var face = {(happySad: String, color: UIColor) -> UIButton in
        let face = UIButton(type: UIButtonType.custom)
        face.setImage(UIImage(named: happySad)!.withRenderingMode(.alwaysTemplate), for: .normal)
        face.imageView?.contentMode = .scaleAspectFit
        face.tintColor = color
        return face
    }
    
    lazy var favoriteActive: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "heartFilled")?.withRenderingMode(.alwaysTemplate)
        image.tintColor = self.heartColorFilled
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var favoriteBtn: UIButton = {
        let heart = self.face("heart", self.heartColor)
        heart.addTarget(self, action: #selector(self.favoriteBtnPressed), for: .touchUpInside)
        return heart
    }()
    
    lazy var happyFace: UIButton = {
        let face = self.face("happy", self.happyColor)
        face.addTarget(self, action: #selector(self.happyBtnPressed), for: .touchUpInside)
        return face
    }()
    
    lazy var sadFace: UIButton = {
        let face = self.face("sad", self.sadColor)
        face.addTarget(self, action: #selector(self.sadBtnPressed), for: .touchUpInside)
        return face
    }()
    
    lazy var happyText: UILabel = {
        let text = UILabel()
        text.text = "0"
        text.font = UIFont.systemFont(ofSize: self.likeDislikeFontSize)
        text.textAlignment = .center
        return text
    }()
    
    lazy var sadText: UILabel = {
        let text = UILabel()
        text.text = "0"
        text.font = UIFont.systemFont(ofSize: self.likeDislikeFontSize)
        text.textAlignment = .center
        return text
    }()
    
    lazy var randomizeBtn: UIButton = {
        let dice = self.face("dice1", self.diceColor)
        dice.addTarget(self, action: #selector(self.randomize), for: .touchUpInside)
        return dice
    }()
    
    lazy var resetBtn: UIButton = {
        let reset = self.face("reset2", self.resetColor)
        reset.addTarget(self, action: #selector(self.reset), for: .touchUpInside)
        return reset
    }()
    
    func favoriteBtnPressed(){
        print("btn pressed")
        favoriteBtn.tintColor = favoriteBtn.isHighlighted ? UIColor.red : UIColor.black
        UIView.animate(withDuration: 0.3, animations: { 
            if self.favoriteActive.isHidden {
                self.favoriteActive.isHidden = false
                //add to favorites
            } else {
                self.favoriteActive.isHidden = true
                //remove from favorites
            }
            
            self.favoriteBtn.transform = CGAffineTransform(scaleX: self.pressedSize, y: self.pressedSize)
            self.favoriteActive.transform = CGAffineTransform(scaleX: self.pressedSize, y: self.pressedSize)
            
        }) { (_) in
            UIView.animate(withDuration: 0.25, animations: { 
                self.favoriteBtn.layer.transform = CATransform3DIdentity
                self.favoriteActive.layer.transform = CATransform3DIdentity
            })
        }
        
        if let window = UIApplication.shared.keyWindow {
            let promptView = PromptView()
            promptView.setUpPrompt(viewAddedTo: window, heightPct: 0.2, widthPct: 0.9, promptMsg: "You liked this!", messageLines: 1, messageOnly: true)
        }
        
    }
    
    func happyBtnPressed() {
        print("Happy face")
    }
    
    func sadBtnPressed() {
        print("Sad face")
    }
    
    func randomize() {
        print("Randomize")
    }
    
    func reset() {
        print("Reset")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
