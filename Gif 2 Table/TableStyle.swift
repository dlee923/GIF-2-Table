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
        self.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2)
        self.tintColor = buttonTintColor
        self.setImage(eyeButton, for: .normal)
        setUpView()
    }
    
    var historyFavCell: HistoryFavoritesCell?
    var isPressed = false
    let animationSpeedOut = 0.1
    let animationSpeedSnap = 0.15
    let buttonColor = UIColor.black
    let buttonTintColor = UIColor.green
    var tableStyle2: TableStyle2?
    let listButton = UIImage(named: "list")?.withRenderingMode(.alwaysTemplate)
    let squaresButton = UIImage(named: "squares")?.withRenderingMode(.alwaysTemplate)
    let eyeButton = UIImage(named: "eye")?.withRenderingMode(.alwaysTemplate)
    
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
            animateDot(isAdding: true, isCopy: false)
            tableStyle2?.animateDot(isAdding: true, isCopy: true)
            self.setImage(listButton, for: .normal)
            tableStyle2?.setImage(squaresButton, for: .normal)
        } else {
            animateDot(isAdding: false, isCopy: false)
            tableStyle2?.animateDot(isAdding: false, isCopy: true)
            //EXECUTE ACTION ON THIS SPLIT
            self.historyFavCell?.animateRecipeList()
            self.setImage(eyeButton, for: .normal)
            tableStyle2?.setImage(nil, for: .normal)
        }
    }
    
    fileprivate func animateDot(isAdding: Bool, isCopy: Bool) {
        
        if isAdding {
            UIView.animate(withDuration: self.animationSpeedOut, delay: 0.0, options: .curveEaseInOut, animations: {
                if isCopy {
                    self.historyFavCell?.tableStyleCenter2?.constant += self.bounds.width
                    self.historyFavCell?.tableStyleWidthConstraint2?.constant = (self.historyFavCell?.tableStyleWidth2)! * 2
                    self.historyFavCell?.tableStyleHeightConstraint2?.constant = (self.historyFavCell?.tableStyleHeight2)! / 1.75
                } else {
                    self.historyFavCell?.tableStyleCenter?.constant -= self.bounds.width
                    self.historyFavCell?.tableStyleWidthConstraint?.constant = (self.historyFavCell?.tableStyleWidth1)! * 2
                    self.historyFavCell?.tableStyleHeightConstraint?.constant = (self.historyFavCell?.tableStyleHeight1)! / 1.75
                }
                
                self.superview?.layoutIfNeeded()
            }) { (_) in
                UIView.animate(withDuration: self.animationSpeedSnap, delay: 0.0, options: .curveEaseOut, animations: {
                    if isCopy {
                        self.historyFavCell?.tableStyleCenter2?.constant += self.bounds.width/2
                        self.historyFavCell?.tableStyleHeightConstraint2?.constant = (self.historyFavCell?.tableStyleHeight2)! * 1.25
                    } else {
                        self.historyFavCell?.tableStyleCenter?.constant -= self.bounds.width/2
                        self.historyFavCell?.tableStyleHeightConstraint?.constant = (self.historyFavCell?.tableStyleHeight1)! * 1.25
                    }
                    
                    self.superview?.layoutIfNeeded()
                    self.backgroundColor = self.buttonColor
                }, completion: nil)
            }
        } else {
            UIView.animate(withDuration: self.animationSpeedOut, delay: 0.0, options: .curveEaseInOut, animations: {
                if isCopy {
                    self.historyFavCell?.tableStyleCenter2?.constant -= self.bounds.width/2
                    self.historyFavCell?.tableStyleWidthConstraint2?.constant = (self.historyFavCell?.tableStyleWidth2)!
                    self.historyFavCell?.tableStyleHeightConstraint2?.constant = (self.historyFavCell?.tableStyleHeight2)! / 1.75
                } else {
                    self.historyFavCell?.tableStyleCenter?.constant += self.bounds.width/2
                    self.historyFavCell?.tableStyleWidthConstraint?.constant = (self.historyFavCell?.tableStyleWidth1)!
                    self.historyFavCell?.tableStyleHeightConstraint?.constant = (self.historyFavCell?.tableStyleHeight1)! / 1.75
                }
                
                self.superview?.layoutIfNeeded()
                self.backgroundColor = .clear
            }) { (_) in
                UIView.animate(withDuration: self.animationSpeedSnap, delay: 0.0, options: .curveEaseOut, animations: {
                    if isCopy {
                        self.historyFavCell?.tableStyleCenter2?.constant -= self.bounds.width
                        self.historyFavCell?.tableStyleHeightConstraint2?.constant = (self.historyFavCell?.tableStyleHeight2)!
                    } else {
                        self.historyFavCell?.tableStyleCenter?.constant += self.bounds.width
                        self.historyFavCell?.tableStyleHeightConstraint?.constant = (self.historyFavCell?.tableStyleHeight1)!
                    }
                    
                    self.superview?.layoutIfNeeded()
                }, completion: nil)
            }
        }
        isPressed = !isPressed
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class TableStyle2: TableStyle {
    
    var tableStyle: TableStyle?
    
    
    override func buttonPressed() {
        if !isPressed {
            animateDot(isAdding: true, isCopy: true)
            tableStyle?.animateDot(isAdding: true, isCopy: false)
        } else {
            animateDot(isAdding: false, isCopy: true)
            tableStyle?.animateDot(isAdding: false, isCopy: false)
            //EXECUTE ACTION ON THIS SPLIT
            self.historyFavCell?.animateRecipeSquares()
            self.setImage(nil, for: .normal)
            tableStyle?.setImage(eyeButton, for: .normal)
        }
    }
}
