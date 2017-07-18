//
//  MenuView.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 7/17/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtonBar

class MenuView: MDCButtonBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
    }
    
    var barButtonItems: [UIBarButtonItem]?
    var buttons: Buttons?
    let menuHeight: CGFloat = 0.1
    var barWidth: CGFloat?
    
    func setUpButtonBar() {
        if let favoritesButton = buttons?.customButton(buttonType: .favorite),
        let homeButton = buttons?.customButton(buttonType: .home),
        let filterButton = buttons?.customButton(buttonType: .filter),
        let _barWidth = barWidth {
            let buttonWidth = _barWidth / 3
            favoritesButton.width = buttonWidth
            homeButton.width = buttonWidth
            filterButton.width = buttonWidth
            barButtonItems = [homeButton, favoritesButton, filterButton]
            self.items = barButtonItems
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
