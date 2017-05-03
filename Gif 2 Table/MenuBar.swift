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
        self.backgroundColor = .purple
        self.dataSource = self
        self.delegate = self
        
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        self.register(MenuCell.self, forCellWithReuseIdentifier: menuCellID)
    }
    
    struct menuOption {
        var name: MenuOptions
        var imageName: String
    }
    
    fileprivate func declareMenuOptions() {
        let feature = menuOption(name: .feature, imageName: "feature1")
        let favorites = menuOption(name: .favorites, imageName: "heart")
        let history = menuOption(name: .history, imageName: "calendar2")
        print("appending")
        menuObjects = [menuOption]()
        menuObjects?.append(favorites)
        menuObjects?.append(feature)
        menuObjects?.append(history)
    }
    
    var mainViewController: MainVC?
    var cellID = "defaultCell"
    var menuCellID = "menuCell"
    var menuObjects: [menuOption]?
    
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
            cell.backgroundColor = .green
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


class MenuCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpCell()
    }
    
    var highlightColor: UIColor = .blue
    var normalColor: UIColor = .darkGray
    
    let menuLabel: UILabel = {
        let label = UILabel()
        label.font = fontHello?.withSize(15)
        label.textAlignment = .center
        return label
    }()
    
    let menuImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .darkGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            self.menuLabel.textColor = isSelected ? highlightColor : normalColor
            self.menuImage.tintColor = isSelected ? highlightColor : normalColor
        }
    }
    
    fileprivate func setUpCell() {
        self.addSubview(menuLabel)
        self.addSubview(menuImage)
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: menuLabel)
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: menuImage)
        self.addConstraintsWithFormat(format: "V:|[v0]-2-[v1(15)]-2-|", views: menuImage, menuLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
