//
//  PlayButton.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 5/1/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class PlayButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButton()
    }
    
    var recipeView: RecipeView?
    let buttonPressedRotation = CGFloat(Double.pi/4)
    let buttonReleasedRotation = CGFloat(Double.pi)
    let animationDuration = 0.25
    let buttonScale: CGFloat = 1.35
    let buttonTransparency: CGFloat = 0.7
    
    func setUpButton() {
        self.layer.cornerRadius = 20
        self.alpha = buttonTransparency
        self.layer.masksToBounds = true
        self.backgroundColor = .black
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("tapped")
        UIView.animate(withDuration: animationDuration) {
            self.transform = CGAffineTransform(rotationAngle: self.buttonPressedRotation).concatenating(CGAffineTransform(scaleX: self.buttonScale, y: self.buttonScale))
            self.transform.scaledBy(x: 1.1, y: 1.1)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: animationDuration) {
            self.layer.transform = CATransform3DIdentity
        }
        recipeView?.playRecipe()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
