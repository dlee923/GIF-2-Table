//
//  MenuBar.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 4/21/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit
import MaterialComponents

enum MenuOptions: String {
    case chicken = "Chicken"
    case steak = "Steak"
    case seafood = "Seafood"
    case salad = "Salad"
    case pasta = "Pasta"
}

class CategoryBar: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        setUpCategoryBar()
        declareMenuOptions()
        self.backgroundView?.backgroundColor = .clear
    }

    var cellID = "defaultCell"
    var menuCellID = "menuCell"
    var menuObjects: [MenuOption]?
    let isPagingEnable = true
    
    func setUpCategoryBarView() {
        
        //animate alpha of cells one by one - rapid fire?
    }
    
    fileprivate func setUpCategoryBar() {
        self.dataSource = self
        self.delegate = self
        
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        self.register(CategoryBarCell.self, forCellWithReuseIdentifier: menuCellID)
    }
    
    fileprivate func declareMenuOptions() {
        let chicken = MenuOption(name: .chicken, imageName: "chicken")
        let steak = MenuOption(name: .steak, imageName: "steak")
        let seafood = MenuOption(name: .seafood, imageName: "seafood")
        let pasta = MenuOption(name: .pasta, imageName: "pasta")
        let salad = MenuOption(name: .salad, imageName: "salad")
        menuObjects = [chicken, steak, seafood, pasta, salad]
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / CGFloat(menuObjects?.count ?? 1), height: self.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCellID, for: indexPath) as? CategoryBarCell {
            cell.menuOption = menuObjects?[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
            return cell
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


