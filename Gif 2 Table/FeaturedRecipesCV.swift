//
//  FeaturedRecipesCV.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 7/15/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialCollections

class FeaturedRecipesCV: MDCCollectionViewController {

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
        setUpCollectionView()
    }
    
    fileprivate func setUpCollectionView() {
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        self.collectionView?.register(FeaturedRecipeCell.self, forCellWithReuseIdentifier: featureCellID)
    }
    
    var recipes: [RecipeObject]?
    let featureCellID = "featureCellID"
    let featureCellWidth: CGFloat = 0.65
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellStyleForSection section: Int) -> MDCCollectionViewCellStyle {
        return .card
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let frame = self.collectionView?.frame {
            return CGSize(width: frame.width * featureCellWidth, height: frame.height)
        }
        return CGSize.zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: featureCellID, for: indexPath) as? FeaturedRecipeCell {
            cell.recipe = recipes?[indexPath.item]
            return cell
        }
        
        return FeaturedRecipeCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
