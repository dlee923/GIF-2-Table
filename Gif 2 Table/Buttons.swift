//
//  Buttons.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 7/17/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

enum ButtonType: String {
    case menu = "menu2"
    case backButton = "ic_chevron_left"
    case favorite = "ic_favorite"
    case home = "ic_home"
    case playButton = "ic_play_circle_outline"
    case filter = "ic_search"
}

class Buttons: UIBarButtonItem {
    
    let buttonSize: CGFloat = 30
    var bottomConstant: CGFloat?
    var mainVC: MainVC?
    var isMenuActive = false
    var isFilterActive = false
    var isFavoriteActive = false
    
    
    lazy var buttonMenu: MenuView = {
        let _buttonMenu = MenuView()
        _buttonMenu.translatesAutoresizingMaskIntoConstraints = false
        if let main = self.mainVC {
            _buttonMenu.barWidth = main.view.frame.width - (main.mainCollectionView.collectionViewSideBorders * 2)
        }
        _buttonMenu.buttons = self
        _buttonMenu.setUpButtonBar()
        return _buttonMenu
    }()
    
    lazy var menuShadowBackground: UIView = {
        let _menuShadowBackground = UIView()
        _menuShadowBackground.backgroundColor = UIColor(white: 0, alpha: 0.2)
        _menuShadowBackground.translatesAutoresizingMaskIntoConstraints = false
        _menuShadowBackground.alpha = 0
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissMenu))
        _menuShadowBackground.addGestureRecognizer(dismissTap)
        return _menuShadowBackground
    }()
    
    var categoryBarView: CategoryBarView?
    
    var bottomConstraint: NSLayoutConstraint?
    
    func customButton(buttonType: ButtonType) -> UIBarButtonItem {
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        button.setImage(UIImage(named: buttonType.rawValue)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = tintedBlack
        
        switch buttonType {
        case .menu: button.addTarget(self, action: #selector(self.activateMenu), for: .touchUpInside)
        case .filter: button.addTarget(self, action: #selector(self.selectFilter), for: .touchUpInside)
        case .favorite: button.addTarget(self, action: #selector(self.selectFavorites), for: .touchUpInside)
        case .home: button.addTarget(self, action: #selector(self.selectHome), for: .touchUpInside)
        default: break
        }
        
        let _customButton = UIBarButtonItem(customView: button)
        
        return _customButton
    }
    
    func emptyButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        button.width = buttonSize
        return button
    }
}
