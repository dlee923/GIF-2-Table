//
//  CustomBackground.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 5/3/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class CustomBackground: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    var blurAlpha: CGFloat = 0.75
    
    func setUpView(backgroundImg: BackgroundImage) {
        self.image = UIImage(named: backgroundImg.rawValue)
        self.contentMode = .scaleAspectFill
        self.addSubview(blurView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: blurView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: blurView)
        blurView.alpha = blurAlpha
    }
    
    lazy var blurView: UIVisualEffectView = {
        let blur = UIVisualEffectView()
        blur.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        return blur
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
