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
        setUpPlayButton()
    }

    var mainVC: MainVC?
    var recipe: RecipeObject?
    
    let playFunctions = PlayVideo()
    
    func setUpPlayButton() {
        self.setElevation(4, for: .normal)
        self.setTitle("Press To Play", for: .normal)
        if let link = recipe?.recipeLink {
            self.addTarget(self, action: #selector(self.playVideo), for: .touchUpInside)
        }
    }
    
    func playVideo() {
        playFunctions.mainViewController = self.mainVC?
        if let link = recipe?.recipeLink {
            playFunctions.playVideo(videoURL: link)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
