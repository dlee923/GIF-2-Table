//
//  EmptyCell.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 4/27/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class EmptyCell: BaseCell {

    override func setUpCell() {
        self.addSubview(emptyLabel2)
        addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: emptyLabel2)
        emptyLabel2.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        emptyLabel2.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    let emptyLabel2: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 2
        label.text = "Your favorite recipes will appear here as you add them!"
        label.font = UIFont(name: "futura", size: 20)
        return label
    }()
    
}
