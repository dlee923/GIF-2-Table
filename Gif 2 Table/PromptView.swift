//
//  PromptView.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 5/4/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class PromptView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setUpPrompt(viewAddedTo: UIView, heightPct: CGFloat, widthPct: CGFloat, promptMsg: String, messageLines: Int, messageOnly: Bool) {
        viewAddedTo.addSubview(self)
        let frameWidth = viewAddedTo.frame.width * widthPct
        let frameHeight = viewAddedTo.frame.height * heightPct
        let endPosition = viewAddedTo.center
        let startPosition = CGPoint(x: viewAddedTo.center.x - (viewAddedTo.frame.width/2) - frameWidth/2, y: viewAddedTo.center.y + 100)
        
        self.bounds.size = CGSize(width: frameWidth, height: frameHeight)
        self.layer.cornerRadius = 5
        self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        if messageOnly {
            self.messageOnly(prompt: promptMsg, messageLines: messageLines)
        } else {
            self.messagePrompts(prompt: promptMsg, messageLines: messageLines)
        }
        
        addCard(startPos: startPosition, EndPos: endPosition)
    }
    
    let message: UILabel = {
        let message = UILabel()
        message.text = "Default Message"
        message.textAlignment = .center
        message.font = fontMandela?.withSize(25)
        message.textColor = .blue
        return message
    }()
    let okayBtn: UIButton = {
        let okay = UIButton()
        okay.setTitle("Okay", for: .normal)
        return okay
    }()
    let cancelBtn: UIButton = {
        let cancel = UIButton()
        cancel.setTitle("Cancel", for: .normal)
        return cancel
    }()
    
    fileprivate func messageOnly(prompt: String, messageLines: Int) {
        self.addSubview(message)
        message.numberOfLines = messageLines
        message.text = prompt
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: message)
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: message)
    }
    
    fileprivate func messagePrompts(prompt: String, messageLines: Int) {
        self.addSubview(message)
        self.addSubview(okayBtn)
        self.addSubview(cancelBtn)
        message.numberOfLines = messageLines
        message.text = prompt
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: message)
        self.addConstraintsWithFormat(format: "H:|[v0][v1]|", views: okayBtn, cancelBtn)
        self.addConstraintsWithFormat(format: "V:|[v0][v1]|", views: message, okayBtn)
        self.addConstraintsWithFormat(format: "V:|[v0][v1]|", views: message, cancelBtn)
    }
    
    fileprivate func addCard(startPos: CGPoint, EndPos: CGPoint) {
        self.center = startPos
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.center = EndPos
            self.transform = CGAffineTransform(rotationAngle: 0)
            self.superview?.layoutSubviews()
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.superview?.layoutSubviews()
            }, completion: {_ in
                UIView.animate(withDuration: 0.2, animations: {
                    self.alpha = 0
                }, completion: { (_) in
                    self.removeFromSuperview()
                })
            } )
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
