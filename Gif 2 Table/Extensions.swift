//
//  Extensions.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 4/21/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewDictionary = [String: UIView]()
        for (index, eachView) in views.enumerated() {
            eachView.translatesAutoresizingMaskIntoConstraints = false
            let key = "v\(index)"
            viewDictionary[key] = eachView
        }
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))
    }
    
    func animateCornerRadius(to: CGFloat, duration: CFTimeInterval) {
        let cornerAnimation = CABasicAnimation(keyPath: "cornerAnimation")
        cornerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        cornerAnimation.fromValue = self.layer.cornerRadius
        cornerAnimation.toValue = to
        cornerAnimation.duration = duration
        self.layer.add(cornerAnimation, forKey: "cornerAnimation")
        self.layer.cornerRadius = to
    }
}

let fontLuna = UIFont(name: "Luna", size: 5)
let fontMandela = UIFont(name: "Mandela Script Personal Use", size: 5)
let fontHello = UIFont(name: "HelloIshBig", size: 5)
let fontMessy = UIFont(name: "KG Life is Messy", size: 5)
let fontReno = UIFont(name: "Renogare", size: 5)

enum BackgroundImage: String {
    case b1 = "background1"
    case b2 = "background2"
    case b3 = "background3"
    case b4 = "background4"
    case b5 = "background5"
    case b6 = "background6"
}

//enum IngredientType: String {
//    case potato = "Potato"
//}

struct IngredientObject {
    var name: String
    var measurement: String
}

var ingredientDictionary: [String : String] = ["Potato" : "Starchy vegetable white in color",
                                               "Salsa" : "Sauce",
                                               "Tequila" : "Chips",
                                               "Corazon" : "Red Stuff"]
