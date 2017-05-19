//
//  SaveFavButton.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 5/8/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class SaveFavButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    let buttonAngle: CGFloat = 0.75
    
    override func draw(_ rect: CGRect) {
        let parallelogram = UIBezierPath()
        parallelogram.move(to: rect.origin)
        parallelogram.addLine(to: CGPoint(x: rect.width * buttonAngle, y: rect.origin.y))
        parallelogram.addLine(to: CGPoint(x: rect.width, y: rect.height))
        parallelogram.addLine(to: CGPoint(x: rect.width * (1 - buttonAngle), y: rect.height))
        parallelogram.close()
        
        let fillColor = tintedBlack
        fillColor.setFill()
        parallelogram.fill()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
