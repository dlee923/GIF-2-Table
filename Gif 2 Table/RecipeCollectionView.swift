//
//  HistoryFavoritesCell.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 4/27/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import Foundation
import UIKit

class RecipeCollectionView: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    override init() {
        super.init()
    }
    
    lazy var recipeList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    var recipes: [RecipeObject]? {
        didSet {
            guard let count = recipes?.count else { return }
            loadMoreButtonActive = count > maxVisibleRecipes ? true : false
            self.recipeList.reloadData()
        }
    }
    
    var loadMoreButtonActive: Bool?
    var maxVisibleRecipes = 6 {
        didSet {
            self.recipeList.reloadData()
        }
    }
    let incrementalRecipeCount = 6
    
    let listedRecipeCellID = "listedRecipeCellID"
    let squareRecipeCellID = "squareRecipeCellID"
    let loadMoreID = "loadMoreID"
    let emptyCellID = "emptyCellID"
    var mainViewController: MainVC?

    let tableRows: CGFloat = 3.5
    let squareRows: CGFloat = 3
    let addRecipeDuration = 0.5
    
    func setUpCollectionView() {
        mainViewController?.view.addSubview(recipeList)
        
        mainViewController?.view.addConstraintsWithFormat(format: "H:|[v0]|", views: recipeList)
        
        mainViewController?.view.addConstraintsWithFormat(format: "V:|[v0]|", views: recipeList)
        
        recipeList.register(ListedRecipeCell.self, forCellWithReuseIdentifier: listedRecipeCellID)
        recipeList.register(SquareRecipeCell.self, forCellWithReuseIdentifier: squareRecipeCellID)
        recipeList.register(EmptyCell.self, forCellWithReuseIdentifier: emptyCellID)
        recipeList.register(EmptyCell.self, forCellWithReuseIdentifier: loadMoreID)
//        
//        if let mainVCHeight = self.mainViewController?.view.frame.height, let categoryBarHeight = self.mainViewController?.categoryBarHeight {
//            self.recipeList.contentInset = UIEdgeInsetsMake((mainVCHeight * categoryBarHeight), 0, 0, 0)
//        }
    }
    
    var isList = true
    
    fileprivate func switchType(isList: Bool ,completion: @escaping () -> () ) {
        self.isList = isList
        recipeList.reloadData()
        recipeList.isHidden = true
        DispatchQueue.main.async {
            completion()
        }
    }
    
    func animateRecipeList() {
        switchType(isList: true) {
//            self.mainViewController?.historyListSwitch = true
            self.recipeList.isHidden = false
            let cells = self.recipeList.visibleCells
            let listHeight = self.recipeList.bounds.height
            
            for cell in cells {
                cell.transform = CGAffineTransform(translationX: 0, y: listHeight + 50)
            }
            
            var cellDelay: Double = 0
            for cell in cells {
                UIView.animate(withDuration: 0.65, delay: 0.05 * cellDelay, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: nil)
                
                cellDelay += 1
            }
        }
    }

    func animateRecipeSquares() {
        switchType(isList: false) {
//            self.mainViewController?.historyListSwitch = false
            self.recipeList.isHidden = false
            let cells = self.recipeList.visibleCells
            let listHeight = self.recipeList.bounds.height/self.squareRows
            let listWidth = self.recipeList.bounds.width
            
            var cellCount = 0
            for cell in cells {
                let row = (cellCount / 2) + 1
                let column = cellCount % 2 + 1
                print(column)
                
                cell.transform = CGAffineTransform(translationX: (listWidth / CGFloat(column)), y: listHeight/CGFloat(row))
                cellCount += 1
            }
            
            var cellDelay: Double = 0
            for cell in cells {
                UIView.animate(withDuration: 0.65, delay: 0.05 * cellDelay, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: nil)
                
                cellDelay += 1
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if recipes?.count == 0 {
            return 1
        } else if loadMoreButtonActive == false {
            return recipes?.count ?? 1
        } else {
            return maxVisibleRecipes + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if recipes?.count == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellID, for: indexPath) as? EmptyCell
            cell?.emptyLabel2.textColor = tintedBlack
            cell?.emptyLabel2.font = UIFont(name: "futura", size: 15)
            return cell ?? UICollectionViewCell()
        } else if loadMoreButtonActive == false {
            
            if isList {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listedRecipeCellID, for: indexPath) as? ListedRecipeCell
                cell?.historyFavCell = self
                cell?.recipe = recipes?[indexPath.item]
                return cell ?? UICollectionViewCell()
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: squareRecipeCellID, for: indexPath) as? SquareRecipeCell
                cell?.historyFavCell = self
                cell?.recipe = recipes?[indexPath.item]
                return cell ?? UICollectionViewCell()
            }
        } else {
            
            if indexPath.item == maxVisibleRecipes {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: loadMoreID, for: indexPath) as? EmptyCell
                cell?.backgroundColor = tintedBlack
                cell?.emptyLabel2.text = "Load More Recipes"
                return cell ?? UICollectionViewCell()
                
            } else {
                if isList {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listedRecipeCellID, for: indexPath) as? ListedRecipeCell
                    cell?.historyFavCell = self
                    cell?.recipe = recipes?[indexPath.item]
                    return cell ?? UICollectionViewCell()
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: squareRecipeCellID, for: indexPath) as? SquareRecipeCell
                    cell?.historyFavCell = self
                    cell?.recipe = recipes?[indexPath.item]
                    return cell ?? UICollectionViewCell()
                }
            }
            
        }
    }
    
    var cellWidth: CGSize?
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if loadMoreButtonActive == false {
            if isList {
                cellWidth = CGSize(width: recipeList.frame.width - 16, height: recipeList.frame.height / tableRows)
            } else {
                cellWidth = CGSize(width: recipeList.frame.width/2, height: recipeList.frame.height / squareRows)
            }
        } else {
            if indexPath.item == maxVisibleRecipes {
                cellWidth = CGSize(width: recipeList.frame.width, height: 70)
            } else {
                if isList {
                    cellWidth = CGSize(width: recipeList.frame.width - 16, height: recipeList.frame.height / tableRows)
                } else {
                    cellWidth = CGSize(width: recipeList.frame.width/2, height: recipeList.frame.height / squareRows)
                }
            }            
        }
        
            
        return cellWidth ?? CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // do nothing as image in cell contains gesture which is connected to call displayRecipeView function
        if indexPath.item == maxVisibleRecipes {
            print("load more recipes")
            guard let count = recipes?.count else { return }
            maxVisibleRecipes = incrementalRecipeCount + maxVisibleRecipes > count ? count : incrementalRecipeCount + maxVisibleRecipes
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ListedRecipeCell else { return }
            displayRecipeView(recipeCell: cell, index: indexPath.item, image: cell.recipeImage.image!)
        }
    }
    
    lazy var recipeView: RecipeView2 = {
        let view = RecipeView2()
        view.historyFavCell = self
        return view
    }()
    
    func displayRecipeView(recipeCell: ListedRecipeCell, index: Int, image: UIImage) {
        
        guard let mainVC = mainViewController else { return }
        
        let image = UIImageView(image: image)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true

        let startingFrame = recipeCell.convert(recipeCell.recipeImage.frame, to: nil)
//        let startingFrame2 = CGRect(x: startingFrame.origin.x, y: startingFrame.origin.y - (mainViewController?.categoryBarHeight ?? 0) - 64, width: startingFrame.width, height: startingFrame.height)
//        image.frame = startingFrame2
        image.backgroundColor = .red

        mainVC.view.addSubview(recipeView)
        mainVC.view.addSubview(image)
        
        recipeView.mainViewController = self.mainViewController
        recipeView.recipe = recipes?[index]        
        recipeView.frame = mainVC.view.bounds
        recipeView.alpha = 0
        
        //animate image into place?
        //"V:|-[v3(30)][v0(40)]-8-[v1]-6-[v2(75)]-86-|" + 4 + 4 FOR FRAMING
        //"V:|-[v0(40)]-8-[v1]-14-[v2(75)]-78-|"
        
        let recipeFrameInset: CGFloat = 4
        
        //MOVING IMAGE INTO FOCUS
        
        UIView.animate(withDuration: addRecipeDuration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { 
            let yMovement = (mainVC.view.frame.height - (mainVC.view.frame.height - 38 - 40 - 8 - recipeFrameInset)) - image.frame.origin.y
            let endFrameHeight = mainVC.view.frame.height - 38 - 40 - 8 - 6 - 75 - 86 - (recipeFrameInset * 2)
            
            var endFrameWidth: CGFloat!
            if self.isList {
                endFrameWidth = image.frame.width - (recipeFrameInset * 2)
                image.transform = CGAffineTransform(translationX: recipeFrameInset, y: yMovement)
            } else {
                endFrameWidth = mainVC.view.frame.width - 8 - (recipeFrameInset * 2) - 8
                if index % 2 == 0 {
                    image.transform = CGAffineTransform(translationX: recipeFrameInset + 4, y: yMovement)
                } else {
                    image.transform = CGAffineTransform(translationX: -mainVC.view.frame.width/2 + recipeFrameInset + 4, y: yMovement)
                }
            }
            
            image.frame.size = CGSize(width: endFrameWidth, height: endFrameHeight)
            self.recipeView.frame = mainVC.view.bounds
            self.recipeList.alpha = 0
            self.recipeView.layoutSubviews()
        }) { (_) in
            UIView.animate(withDuration: self.addRecipeDuration/2, animations: {
                self.recipeView.alpha = 1.0
            }, completion: { (_) in
                image.removeFromSuperview()
            })
        }
        
        image.animateCornerRadius(to: 10, duration: 2.0)
    }
}
