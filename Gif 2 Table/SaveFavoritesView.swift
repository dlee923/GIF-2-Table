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
    let heartColor = UIColor.red
    let heartColorFilled = UIColor.white
    let pressedSize: CGFloat = 1.3
    
    func setUpView() {
        self.backgroundColor = .clear
        self.addSubview(happyFace)
        self.addSubview(sadFace)
        self.addSubview(happyText)
        self.addSubview(sadText)
        self.addSubview(favoriteActive)
        self.addSubview(favoriteBtn)
        favoriteActive.isHidden = true
        
        addConstraintsWithFormat(format: "H:[v1(70)][v0(70)]|", views: sadFace, happyFace)
        addConstraintsWithFormat(format: "H:[v1(70)][v0(70)]|", views: sadText, happyText)
        
        addConstraintsWithFormat(format: "V:|[v0]-4-[v1(10)]-5-|", views: sadFace, sadText)
        happyFace.heightAnchor.constraint(equalTo: sadFace.heightAnchor, multiplier: 1).isActive = true
        addConstraintsWithFormat(format: "V:|-15-[v0]-4-[v1(10)]", views: happyFace, happyText)
        
        addConstraintsWithFormat(format: "H:|[v0(75)]", views: favoriteActive)
        addConstraintsWithFormat(format: "V:|-[v0]|", views: favoriteActive)
        addConstraintsWithFormat(format: "H:|[v0(75)]", views: favoriteBtn)
        addConstraintsWithFormat(format: "V:|-[v0]|", views: favoriteBtn)
        
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
    
    func favoriteBtnPressed(){
        print("btn pressed")
        
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
    }
    
    lazy var happyFace: UIButton = {
        let face = self.face("happy", self.happyColor)
        return face
    }()
    
    lazy var sadFace: UIButton = {
        let face = self.face("sad", self.sadColor)
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
