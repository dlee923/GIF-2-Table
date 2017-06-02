//
//  MenuBar.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 4/21/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

enum MenuOptions: String {
    case feature = "Feature"
    case favorites = "Favorites"
    case history = "Past Meals"
}

class MenuBar: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        declareMenuOptions()
        self.backgroundColor = UIColor(white: 0, alpha: 0.35)
        self.dataSource = self
        self.delegate = self
        
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        self.register(MenuCell.self, forCellWithReuseIdentifier: menuCellID)
    }
    
    var mainViewController: MainVC?
    var cellID = "defaultCell"
    var menuCellID = "menuCell"
    var menuObjects: [menuOption]?
    
    struct menuOption {
        var name: MenuOptions
        var imageName: String
    }
    
    fileprivate func declareMenuOptions() {
        let feature = menuOption(name: .feature, imageName: "feature2")
        let favorites = menuOption(name: .favorites, imageName: "favorites1")
        let history = menuOption(name: .history, imageName: "pot1")
        print("appending")
        menuObjects = [menuOption]()
        menuObjects?.append(favorites)
        menuObjects?.append(feature)
        menuObjects?.append(history)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = menuObjects?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCellID, for: indexPath) as? MenuCell {            
            cell.menuLabel.text = menuObjects?[indexPath.item].name.rawValue
            if let imageName = menuObjects?[indexPath.item].imageName {
                cell.menuImage.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width/3, height: self.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mainViewController?.scrollToPage(itemNumber: indexPath.item)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


