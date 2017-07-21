//
//  RecipeViewTouch.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 7/20/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

extension RecipeView {

    func addSwipeGestureToRemoveView() {
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .right
        swipe.addTarget(self, action: #selector(self.swipeToRemoveView))
        self.swipeView.addGestureRecognizer(swipe)
    }

}
