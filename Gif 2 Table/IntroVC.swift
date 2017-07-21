//
//  IntroVC.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 7/20/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialFeatureHighlight

class IntroVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateRecipeView()
        instantiateTutorialView()
    }
    
    var recipeView: RecipeView?
    
    let helloView = UIView()
    
    let fadeDuration: Double = 0.5
    
    let greetingsLabel: UILabel = {
        let _greetingsLabel = UILabel()
        _greetingsLabel.translatesAutoresizingMaskIntoConstraints = false
        _greetingsLabel.numberOfLines = 2
        _greetingsLabel.font = fontPorter?.withSize(16)
        _greetingsLabel.textAlignment = .center
        _greetingsLabel.textColor = globalBlueColor
        _greetingsLabel.text = "Welcome!"
        _greetingsLabel.alpha = 0
        return _greetingsLabel
    }()
    
    var featureHighlight: MDCFeatureHighlightViewController?
    
    func instantiateRecipeView() {
        recipeView = RecipeView(frame: self.view.frame)
        recipeView?.setUpView()
        recipeView?.recipeImage.image = UIImage(named: "steak")
        recipeView?.ingredientList?.ingredients = [IngredientObject(name: "Hangar Steak", imageName: "", measurement: "1 Lbs."), IngredientObject(name: "Ground Pepper", imageName: "", measurement: "To Taste"), IngredientObject(name: "Crushed Sea Salt", imageName: "", measurement: "To Taste"), IngredientObject(name: "Cilantro", imageName: "", measurement: "1 Cup"), IngredientObject(name: "Red Vinegar", imageName: "", measurement: "1/2 Cup")]
        
        let highlightedView = UILabel(frame: CGRect(x: 30, y: ((recipeView?.frame.height)! * 0.9) - 15, width: (recipeView?.frame.width)! - 60, height: (recipeView?.frame.height)! * 0.1))
        highlightedView.backgroundColor = tintedBlack
        highlightedView.textColor = .white
        highlightedView.textAlignment = .center
        highlightedView.text = "Press To Play"
        highlightedView.font = fontReno?.withSize(12)
        
        featureHighlight = MDCFeatureHighlightViewController(highlightedView: highlightedView, andShow: highlightedView, completion: { (_) in
            print("move to real app and flip switch to not play again")
            self.dismiss(animated: true, completion: nil)
        })

//        featureHighlight = MDCFeatureHighlightViewController(highlightedView: highlightedView) { (_) in
//            // do what here?
//            print("move to real app and flip switch to not play again")
//        }
        featureHighlight?.outerHighlightColor = globalBlueColor
        featureHighlight?.innerHighlightColor = globalBeigeColor
        featureHighlight?.titleText = "Play Recipes!"
        featureHighlight?.bodyText = "Press this button to play recipes!  It's that simple!"
    
        self.view.addSubview(recipeView!)
        
        self.view.addSubview(highlightedView)
    }
    
    func instantiateTutorialView() {
        helloView.frame = self.view.bounds
        helloView.backgroundColor = globalBeigeColor
        self.view.addSubview(helloView)
    
        self.helloView.addSubview(greetingsLabel)
        greetingsLabel.centerXAnchor.constraint(equalTo: self.helloView.centerXAnchor).isActive = true
        greetingsLabel.centerYAnchor.constraint(equalTo: self.helloView.centerYAnchor).isActive = true
        greetingsLabel.widthAnchor.constraint(equalTo: self.helloView.widthAnchor, multiplier: 0.7).isActive = true
        greetingsLabel.heightAnchor.constraint(equalTo: self.helloView.heightAnchor, multiplier: 0.2).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            self.changeMessage()
        }
    }
    
    func changeMessage() {
        UIView.animate(withDuration: self.fadeDuration, animations: {
            self.greetingsLabel.alpha = 1
        }) { (_) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.changeMessage2()
            }
        }
    }
    
    func changeMessage2() {
        UIView.animate(withDuration: self.fadeDuration, animations: {
            self.greetingsLabel.alpha = 0
        }) { (_) in
            self.greetingsLabel.text = "To the better way to follow recipes."
            UIView.animate(withDuration: self.fadeDuration, animations: {
                self.greetingsLabel.textColor = globalBeigeColor
                self.helloView.backgroundColor = globalBlueColor
                self.greetingsLabel.alpha = 1
            }, completion: { (_) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                    self.changeMessage3()
                }
            })
        }
    }
    
    func changeMessage3() {
        UIView.animate(withDuration: self.fadeDuration, animations: {
            self.greetingsLabel.alpha = 0
        }) { (_) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.fadeOutView()
            }
        }
    }
    
    func fadeOutView() {
        UIView.animate(withDuration: self.fadeDuration, animations: {
            self.helloView.alpha = 0
        }, completion: { (_) in
            self.helloView.removeFromSuperview()
            self.present(self.featureHighlight!, animated: true, completion: {
                // do something?
            })
        })
    }
}
