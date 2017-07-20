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
    case meat = "Meat"
    case seafood = "Seafood"
    case greens = "Greens"
    case pasta = "Pasta"
}

class CategoryBar: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        setUpCategoryBar()
        declareMenuOptions()
        self.backgroundColor = .clear
        self.backgroundView?.backgroundColor = .clear
    }

    var cellID = "defaultCell"
    var menuCellID = "menuCell"
    var menuObjects: [MenuOption]?
    let isPagingEnable = true
    var mainVC: MainVC?
    var menuButton: Buttons?
    
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
        let meat = MenuOption(name: .meat, imageName: "steak")
        let seafood = MenuOption(name: .seafood, imageName: "seafood")
        let pasta = MenuOption(name: .pasta, imageName: "pasta")
        let greens = MenuOption(name: .greens, imageName: "salad")
        menuObjects = [chicken, meat, seafood, pasta, greens]
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
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCellID, for: indexPath) as? CategoryBarCell {
            cell.menuImage.alpha = 0.5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCellID, for: indexPath) as? CategoryBarCell {
            cell.menuImage.alpha = 1.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCellID, for: indexPath) as? CategoryBarCell {
            cell.menuOption = menuObjects?[indexPath.item]
            cell.alpha = 0
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let filteredCategory = menuObjects?[indexPath.item].name.rawValue
        print("filtering selection")
        
        guard let main = mainVC else { return }
        main.mainCollectionView.isFavorites = false
        main.mainCollectionView.isFilteredByFood = true
        main.mainCollectionView.filterCategoryTitle = filteredCategory
            
        main.mainCollectionView.recipes = main.recipes.filter({ (recipe) -> Bool in
            recipe.category == filteredCategory
        })
        
        main.mainCollectionView.collectionView?.reloadData()
        menuButton?.activateMenu()
        menuButton?.isFavoriteActive = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


