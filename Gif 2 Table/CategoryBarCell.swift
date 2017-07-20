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
        label.font = fontReno?.withSize(11)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let menuImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
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
    
    var imageSize: CGFloat?
    let imageSizeScale: CGFloat = 0.9
    
    fileprivate func setUpCell() {        
        self.addSubview(menuImage)
        self.addSubview(menuLabel)
        
        for view in self.subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        imageSize = self.frame.width < self.frame.height ? self.frame.width : self.frame.height
        
        if let _imageSize = imageSize {
            let scaledImageSize = _imageSize * imageSizeScale
            menuImage.widthAnchor.constraint(equalToConstant: scaledImageSize).isActive = true
            menuImage.heightAnchor.constraint(equalToConstant: scaledImageSize).isActive = true
            menuImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            menuImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 7).isActive = true
            menuImage.layer.cornerRadius = scaledImageSize / 2
        }
        
        menuLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        menuLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        menuLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        menuLabel.topAnchor.constraint(equalTo: menuImage.bottomAnchor, constant: 5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
