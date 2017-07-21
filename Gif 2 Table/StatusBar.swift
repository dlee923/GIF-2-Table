//
//  StatusBar.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 7/18/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons

class StatusBar: MDCRaisedButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setBackgroundColor(tintedBlack, for: .normal)
        self.titleLabel?.font = fontReno?.withSize(12)
        self.setTitleColor(UIColor.white, for: .normal)
        setUpPlayButton()
    }

    var mainVC: MainVC?
    var recipe: RecipeObject?
    
    let playFunctions = PlayVideo()
    
    let playImage: UIImageView = {
        let _playImage = UIImageView(image: UIImage(named: "ic_play_circle_outline")?.withRenderingMode(.alwaysTemplate))
        _playImage.tintColor = .white
        _playImage.backgroundColor = tintedBlack
        _playImage.contentMode = .center
        _playImage.translatesAutoresizingMaskIntoConstraints = false
        return _playImage
    }()
    
    let playLabel = UILabel()
    
    func setUpPlayButton() {
        self.setElevation(4, for: .normal)
        self.setTitle("Press To Play!", for: .normal)
        self.addTarget(self, action: #selector(self.playVideo), for: .touchUpInside)

        self.addSubview(playImage)
        playImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        playImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        playImage.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
    }
    
    
    func playVideo() {                
        slideOffRecipe(shouldRemove: false, recipeView: nil)
        
        playFunctions.mainViewController = self.mainVC
        if let link = recipe?.recipeLink {
            playFunctions.playVideo(videoURL: link)
        }
    }
    
    func slideOffRecipe(shouldRemove: Bool, recipeView: RecipeView?) {
        // slide off in preparation for playing video
        guard let newOriginPoint = mainVC?.view.frame.width else { return }
        UIView.animate(withDuration: 0.3, animations: { 
            self.mainVC?.mainCollectionView.recipeView?.transform = CGAffineTransform(translationX: newOriginPoint, y: 0)
        }) { (_) in
            if shouldRemove {
                recipeView?.removeFromSuperview()
            }
        }
    }
    
    func slideOnRecipe() {
        UIView.animate(withDuration: 0.3, animations: {
            self.mainVC?.mainCollectionView.recipeView?.transform = CGAffineTransform.identity
        }) { (_) in
            // do something
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
