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
        
        declareMenuOptions()
        setUpCategoryBar()
        self.backgroundView?.backgroundColor = .clear
    }
    
    var mainVC: MainVC?
    var cellID = "defaultCell"
    var menuCellID = "menuCell"
    var menuObjects: [MenuOption]?
    let isPagingEnable = true
    
    func setUpCategoryBarView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isPagingEnabled = isPagingEnable
        
        guard let main = mainVC else { return }
        main.view.addSubview(self)
        
        self.leadingAnchor.constraint(equalTo: main.view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: main.view.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: main.view.topAnchor).isActive = true
//        self.heightAnchor.constraint(equalTo: main.view.heightAnchor, multiplier: main.categoryBarHeight).isActive = true
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCellID, for: indexPath) as? CategoryBarCell {
            cell.menuOption = menuObjects?[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


