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
        self.addSubview(emptyLabel)
        addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: emptyLabel)
        emptyLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    let emptyLabel: UITextView = {
        let label = UITextView()
        label.backgroundColor = .clear
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: "Your favorite recipes will appear here as you add them!", attributes: [NSFontAttributeName: UIFont(name: "futura", size: 15), NSForegroundColorAttributeName: UIColor.black])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let textLength = attributedText.string.characters.count
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, textLength))
        
        label.attributedText = attributedText
        return label
    }()
    
}
