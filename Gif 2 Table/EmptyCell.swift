//
//  EmptyCell.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 4/27/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

enum EmptyMessage: String {
    case noFavorites = "No favorite recipes have been selected."
    case noRecipes = "Unable to download recipes from server..."
}

class EmptyCell: BaseCell {

    override func setUpCell() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
    func setUpEmptyPrompt(type: EmptyMessage) {
        self.addSubview(emptyLabel)
        emptyLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        emptyLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6).isActive = true
        emptyLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        emptyLabel.text = type.rawValue
        
        self.addSubview(appIcon)
        appIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8).isActive = true
        appIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: -20).isActive = true
        appIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 20).isActive = true
        appIcon.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
    }
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = tintedBlack.withAlphaComponent(0.65)
        label.numberOfLines = 2
        label.font = fontReno?.withSize(12)
        return label
    }()
    
    let appIcon: UIImageView = {
        let _appIcon = UIImageView()
        _appIcon.translatesAutoresizingMaskIntoConstraints = false
        _appIcon.contentMode = .scaleAspectFill
        _appIcon.image = UIImage(named: "g2tplaceholder")?.withRenderingMode(.alwaysTemplate)
        _appIcon.tintColor = tintedBlack.withAlphaComponent(0.2)
        return _appIcon
    }()
    
}
