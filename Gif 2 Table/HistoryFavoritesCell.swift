//
//  HistoryFavoritesCell.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 4/27/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import Foundation
import UIKit

class HistoryFavoritesCell: BaseCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    override func setUpCell() {
        setUpCollectionView()
    }
    
    lazy var recipeList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    var recipes: [RecipeObject]?
    
    let listedRecipeCellID = "listedRecipeCellID"
    let emptyCellID = "emptyCellID"
    var mainViewController: MainVC?
    
    func setUpCollectionView() {
        self.addSubview(recipeList)
        addConstraintsWithFormat(format: "H:|[v0]|", views: recipeList)
        addConstraintsWithFormat(format: "V:|[v0]|", views: recipeList)
        
        recipeList.register(ListedRecipeCell.self, forCellWithReuseIdentifier: listedRecipeCellID)
        recipeList.register(EmptyCell.self, forCellWithReuseIdentifier: emptyCellID)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if recipes?.count == 0 {
            return 1
        } else {
            return recipes?.count ?? 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if recipes!.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellID, for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listedRecipeCellID, for: indexPath) as? ListedRecipeCell
            cell?.historyFavCell = self
            cell?.recipe = recipes?[indexPath.item]
            return cell ?? UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: recipeList.frame.width, height: recipeList.frame.height / 3.5)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // do nothing as image in cell contains gesture which is connected to call displayRecipeView function
        print(self.frame)
        guard let cell = collectionView.cellForItem(at: indexPath) as? ListedRecipeCell else { return }
        displayRecipeView(recipeCell: cell, index: indexPath.item, image: cell.recipeImage.image!)
    }
    
    lazy var recipeView: RecipeView = {
        let view = RecipeView()
        view.backgroundColor = .orange
        return view
    }()
    
    func displayRecipeView(recipeCell: ListedRecipeCell, index: Int, image: UIImage) {
        let image = UIImageView(image: image)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true

        let startingFrame = recipeCell.convert(recipeCell.recipeImage.frame, to: nil)
        let startingFrame2 = CGRect(x: startingFrame.origin.x, y: startingFrame.origin.y - (mainViewController?.menuBarHeight ?? 0) - 64, width: startingFrame.width, height: startingFrame.height)
        image.frame = startingFrame2
        image.backgroundColor = .red

        self.addSubview(recipeView)
        self.addSubview(image)
        
        recipeView.recipe = recipes?[index]
        recipeView.mainViewController = self.mainViewController
        recipeView.frame = self.bounds
        recipeView.alpha = 0
        
        //animate image into place?
        //"V:|-[v0(40)]-8-[v1]-12-[v2(40)]-80-|"
        
        UIView.animate(withDuration: 1.0, animations: {
            let yMovement = (self.frame.height - (self.frame.height - 8 - 40 - 8)) - image.frame.origin.y
            let endFrame = self.frame.height - 8 - 40 - 8 - 12 - 40 - 80
            image.transform = CGAffineTransform(translationX: 0, y: yMovement)
            image.frame.size = CGSize(width: image.frame.width, height: endFrame)
            self.recipeView.frame = self.bounds
            self.recipeView.layoutSubviews()
        }, completion: { (_) in
            UIView.animate(withDuration: 1.0, animations: {
                self.recipeView.alpha = 1.0
//                image.alpha = 0
            }, completion: { (_) in
                image.removeFromSuperview()
            })
        })
        
        image.animateCornerRadius(to: 10, duration: 2.0)
        
        print("called")
    }
}
