//
//  TitleView.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 7/13/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class TitleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    var mainVC: MainVC?
    
    lazy var titleLabel: UILabel = {
        let _titleLabel = UILabel()
        _titleLabel.text = "GIF 2 Table"
        _titleLabel.textColor = .black
        _titleLabel.textAlignment = .center
        _titleLabel.font = fontGeo?.withSize(self.titleFontSize)
        return _titleLabel
    }()
    
    let titleFontSize: CGFloat = 15
    
    let titleLogo: UIImageView = {
        let _titleLogo = UIImageView()
        _titleLogo.image = UIImage(named: "g2tplaceholder")?.withRenderingMode(.alwaysTemplate)
        _titleLogo.contentMode = .scaleAspectFit
        _titleLogo.tintColor = tintedBlack
        _titleLogo.alpha = 0
        return _titleLogo
    }()
    
    func setUpView() {        
        self.addSubview(titleLogo)
        self.addSubview(titleLabel)
        
        titleLogo.translatesAutoresizingMaskIntoConstraints = false
        titleLogo.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleLogo.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        titleLogo.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
