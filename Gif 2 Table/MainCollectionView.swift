//
//  MainCollectionView.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 7/14/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialCollections

class MainCollectionView: MDCCollectionViewController {
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionView?.backgroundColor = globalBackgroundColor
        
        setUpCollectionView()
    }
    
    var recipes: [RecipeObject]?
    var mainVC: MainVC?
    let recipesPerView: CGFloat = 2.5
    let featureCellHeight: CGFloat = 0.2
    let collectionViewSideBorders: CGFloat = 10
    
    let mainRecipeCell = "mainRecipeCell"
    let mainHeaderCell = "mainHeaderCell"
    let mainFeatureCell = "mainFeatureCell"
    
    fileprivate func setUpCollectionView() {
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.register(MainRecipeCell.self, forCellWithReuseIdentifier: mainRecipeCell)
        self.collectionView?.register(MainFeatureCell.self, forCellWithReuseIdentifier: mainFeatureCell)
        self.collectionView?.register(MainHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: mainHeaderCell)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let recipeCount = recipes?.count {
            print("recipe count is \(recipeCount)")
            switch section {
            case 0: return 1
            case 1: return recipeCount
            default: break
            }
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let main = mainVC {
            return CGSize(width: main.view.frame.width, height: 40)
        }
        return CGSize.zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let main = mainVC {
            let featuredCellSize = CGSize(width: main.view.frame.width, height: main.view.frame.height * featureCellHeight)
            let normalCellSize = CGSize(width: main.view.frame.width - (collectionViewSideBorders * 2), height: main.view.frame.height / recipesPerView)
            
            switch indexPath.section {
            case 0: return featuredCellSize
            case 1: return normalCellSize
            default: break
            }
        }
        return CGSize.zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellStyleForSection section: Int) -> MDCCollectionViewCellStyle {
        if section == 1 {
            return .card
        }
        return .card
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: mainHeaderCell, for: indexPath) as? MainHeaderCell {
            
            header.collectionViewSideSpacing = self.collectionViewSideBorders
            
            switch indexPath.section {
            case 0: header.headerLabel.text = "FEATURE RECIPES"
            case 1: header.headerLabel.text = "LATEST"
            default: break
            }
            
            return header
        }
        
        return MainHeaderCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {        
        if indexPath.section == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainFeatureCell, for: indexPath) as? MainFeatureCell {
                
                return cell
            }
        } else if indexPath.section == 1 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainRecipeCell, for: indexPath) as? MainRecipeCell {
                cell.recipe = self.recipes?[indexPath.item]
                return cell
            }
        }

        return UICollectionViewCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
