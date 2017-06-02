//
//  MenuBarCell.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 6/2/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpCell()
    }
    
    let highlightColor: UIColor = .green
    let normalColor: UIColor = tintedBlack
    let textHighlight: UIColor = .white
    
    let menuLabel: UILabel = {
        let label = UILabel()
        label.font = fontMessy?.withSize(12)
        label.textAlignment = .center
        return label
    }()
    
    let menuImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .darkGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            self.menuLabel.textColor = isSelected ? textHighlight : normalColor
            self.menuImage.tintColor = isSelected ? highlightColor : normalColor
        }
    }
    
    fileprivate func setUpCell() {
        self.addSubview(menuLabel)
        self.addSubview(menuImage)
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: menuLabel)
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: menuImage)
        self.addConstraintsWithFormat(format: "V:|-7-[v0]-5-[v1(15)]-2-|", views: menuImage, menuLabel)
        
        self.menuLabel.textColor = isSelected ? highlightColor : normalColor
        self.menuImage.tintColor = isSelected ? highlightColor : normalColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
