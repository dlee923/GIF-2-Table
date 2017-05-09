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
    
    func setUpPrompt(heightPct: CGFloat, widthPct: CGFloat, promptMsg: String, messageLines: Int, messageOnly: Bool, doesDisappear: Bool) {
        
        guard let window = UIApplication.shared.keyWindow else { return }
        
        window.addSubview(self)
        let frameWidth = window.frame.width * widthPct
        let frameHeight = window.frame.height * heightPct
        let endPosition = window.center
        let startPosition = CGPoint(x: window.center.x - (window.frame.width/2) - frameWidth/2, y: window.center.y + 100)
        
        self.bounds.size = CGSize(width: frameWidth, height: frameHeight)
        self.layer.cornerRadius = 5
        self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        if messageOnly {
            self.messageOnly(prompt: promptMsg, messageLines: messageLines)
        } else {
            self.messagePrompts(prompt: promptMsg, messageLines: messageLines)
        }
        
        addCard(startPos: startPosition, EndPos: endPosition, doesDisappear: doesDisappear)
    }
    
    let message: UILabel = {
        let message = UILabel()
        message.text = "Default Message"
        message.textAlignment = .center
        message.font = UIFont.systemFont(ofSize: 15, weight: 0.5)
        message.textColor = .green
        return message
    }()
    
    lazy var okayBtn: UIButton = {
        let okay = UIButton()
        okay.backgroundColor = .purple
        okay.titleLabel?.textAlignment = .center
        okay.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: 0.5)
        okay.setTitle("Yup", for: .normal)
        okay.addTarget(self, action: #selector(self.okayBtnPressed), for: .touchUpInside)
        return okay
    }()
    lazy var cancelBtn: UIButton = {
        let cancel = UIButton()
        cancel.backgroundColor = .purple
        cancel.titleLabel?.textAlignment = .center
        cancel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: 0.5)
        cancel.setTitle("Nope", for: .normal)
        cancel.addTarget(self, action: #selector(self.cancelBtnPressed), for: .touchUpInside)
        return cancel
    }()
    
    fileprivate func messageOnly(prompt: String, messageLines: Int) {
        self.addSubview(message)
        message.numberOfLines = messageLines
        message.text = prompt
        self.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: message)
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: message)
    }
    
    fileprivate func messagePrompts(prompt: String, messageLines: Int) {
        self.addSubview(message)
        self.addSubview(okayBtn)
        self.addSubview(cancelBtn)
        message.numberOfLines = messageLines
        message.text = prompt
        self.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: message)
        self.addConstraintsWithFormat(format: "H:|[v0]-2-[v1(v0)]|", views: okayBtn, cancelBtn)
        self.addConstraintsWithFormat(format: "V:|[v0][v1]|", views: message, okayBtn)
        self.addConstraintsWithFormat(format: "V:|[v0][v1]|", views: message, cancelBtn)
    }
    
    func cancelBtnPressed() {
        self.removeFromSuperview()
    }
    
    func okayBtnPressed() {
        print("okay pressed")
    }
    
    fileprivate func addCard(startPos: CGPoint, EndPos: CGPoint, doesDisappear: Bool) {
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
                
                if doesDisappear {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.alpha = 0
                    }, completion: { (_) in
                        self.removeFromSuperview()
                    })
                }
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
