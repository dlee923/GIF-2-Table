//
//  TableStyle.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 5/4/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class TableStyle: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
        setUpView()
    }
    
    var historyFavCell: HistoryFavoritesCell?
    var isPressed = false
    let animationSpeed1 = 0.1
    let animationSpeed2 = 0.25
    let buttonColor = UIColor.green
    
    override func draw(_ rect: CGRect) {
        let fillColor = buttonColor
        fillColor.setFill()
        let circleShape = UIBezierPath(ovalIn: self.bounds)
        circleShape.fill()
        
    }
    
    fileprivate func setUpView() {
        self.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
    }
    
    func buttonPressed() {
        if !isPressed {
            animateDot(isAdding: true)
        } else {
            animateDot(isAdding: false)
        }
        isPressed = !isPressed
    }
    
    fileprivate func animateDot(isAdding: Bool) {
        if isAdding {
            UIView.animate(withDuration: self.animationSpeed1, delay: 0.0, options: .curveEaseInOut, animations: {
                self.historyFavCell?.tableStyleCenter?.constant += self.bounds.width
                self.superview?.layoutIfNeeded()
                self.bounds.size = CGSize(width: self.bounds.width * CGFloat(2), height: self.bounds.height/1.75)
                
            }) { (_) in
                UIView.animate(withDuration: self.animationSpeed2, delay: 0.0, options: .curveEaseOut, animations: {
                    self.historyFavCell?.tableStyleCenter?.constant += self.bounds.width/2
                    self.superview?.layoutIfNeeded()
                    self.bounds.size = CGSize(width: self.bounds.width, height: self.bounds.height)
                    self.backgroundColor = self.buttonColor
                }, completion: nil)
            }
        } else {
            UIView.animate(withDuration: self.animationSpeed1, delay: 0.0, options: .curveEaseInOut, animations: {
                self.historyFavCell?.tableStyleCenter?.constant -= self.bounds.width
                self.superview?.layoutIfNeeded()
                self.bounds.size = CGSize(width: self.bounds.width * CGFloat(2), height: self.bounds.height/1.75)
                self.backgroundColor = .clear
                
            }) { (_) in
                UIView.animate(withDuration: self.animationSpeed2, delay: 0.0, options: .curveEaseOut, animations: {
                    self.historyFavCell?.tableStyleCenter?.constant -= self.bounds.width/2
                    self.superview?.layoutIfNeeded()
                    self.bounds.size = CGSize(width: self.bounds.width, height: self.bounds.height)
                }, completion: nil)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
