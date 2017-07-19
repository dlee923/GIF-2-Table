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
        self.clipsToBounds = true
        self.setTitleColor(UIColor.white, for: .normal)
        setUpPlayButton()
    }

    var mainVC: MainVC?
    var recipe: RecipeObject?
    
    let playFunctions = PlayVideo()
    
    let playImage = UIImageView(image: UIImage(named: "ic_play_circle_outline")?.withRenderingMode(.alwaysTemplate))
    let playLabel = UILabel()
    
    func setUpPlayButton() {
        self.setElevation(4, for: .normal)
        
        self.addTarget(self, action: #selector(self.playVideo), for: .touchUpInside)
        playImage.tintColor = .white
        
        self.addSubview(playImage)
        playImage.contentMode = .center
        playImage.translatesAutoresizingMaskIntoConstraints = false
        playImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        playImage.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        playImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        playImage.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    
    func playVideo() {
        print("playing video")
        
        slideOffRecipe()
        
        playFunctions.mainViewController = self.mainVC
        if let link = recipe?.recipeLink {
            playFunctions.playVideo(videoURL: link)
        }
    }
    
    func slideOffRecipe() {
        // slide off in preparation for playing video
        let originPointX = mainVC?.mainCollectionView.recipeView?.frame.origin.x
        guard let newOriginPoint = mainVC?.view.frame.width else { return }
        UIView.animate(withDuration: 0.3, animations: { 
            self.mainVC?.mainCollectionView.recipeView?.transform = CGAffineTransform(translationX: newOriginPoint, y: 0)
        }) { (_) in
            // do something
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
