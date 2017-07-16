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
    let titleLabel = UILabel()
    let titleFontSize: CGFloat = 15
    
    func setUpView() {
        titleLabel.text = "GIF 2 Table"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = fontGeo?.withSize(titleFontSize)
        
        self.addSubview(titleLabel)
        
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
