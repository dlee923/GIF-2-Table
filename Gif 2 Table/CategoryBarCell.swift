//
//  MenuBarCell.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 6/2/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

struct MenuOption {
    var name: MenuOptions
    var imageName: String
}

class CategoryBarCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpCell()
    }
    
    let menuLabel: UILabel = {
        let label = UILabel()
        label.font = fontMessy?.withSize(12)
        label.textAlignment = .center
        return label
    }()
    
    let menuImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var menuOption: MenuOption? {
        didSet {
            self.menuLabel.text = menuOption?.name.rawValue
            if let imageName = menuOption?.imageName {
                self.menuImage.image = UIImage(named: imageName)
            }
        }
    }
    
    fileprivate func setUpCell() {        
        self.addSubview(menuImage)
        self.addSubview(menuLabel)
        
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: menuLabel)
        self.addConstraintsWithFormat(format: "V:[v0(15)]-|", views: menuLabel)
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: menuImage)
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: menuImage)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
