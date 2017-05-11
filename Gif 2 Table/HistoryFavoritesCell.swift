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
    
    lazy var tableStyle: TableStyle = {
        let button = TableStyle()
        button.translatesAutoresizingMaskIntoConstraints = false
        self.tableStyleHeightConstraint = button.heightAnchor.constraint(equalToConstant: self.tableStyleHeight1)
        self.tableStyleHeightConstraint?.isActive = true
        self.tableStyleWidthConstraint = button.widthAnchor.constraint(equalToConstant: self.tableStyleWidth1)
        self.tableStyleWidthConstraint?.isActive = true
        button.historyFavCell = self
        return button
    }()
    
    lazy var tableStyle2: TableStyle2 = {
        let button = TableStyle2()
        button.translatesAutoresizingMaskIntoConstraints = false
//        self.tableStyleHeightConstraint2 = button.heightAnchor.constraint(equalToConstant: self.tableStyleHeight2)
//        self.tableStyleHeightConstraint2?.isActive = true
        self.tableStyleWidthConstraint2 = button.widthAnchor.constraint(equalToConstant: self.tableStyleWidth2)
        self.tableStyleWidthConstraint2?.isActive = true
        button.historyFavCell = self
        return button
    }()
    
    var tableStyleCenter: NSLayoutConstraint?
    var tableStyleWidthConstraint: NSLayoutConstraint?
    var tableStyleHeightConstraint: NSLayoutConstraint?
    var tableStyleCenter2: NSLayoutConstraint?
    var tableStyleWidthConstraint2: NSLayoutConstraint?
    var tableStyleHeightConstraint2: NSLayoutConstraint?
    
    lazy var recipeList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    var recipes: [RecipeObject]? {
        didSet {
            self.recipeList.reloadData()
        }
    }
    
    let listedRecipeCellID = "listedRecipeCellID"
    let squareRecipeCellID = "squareRecipeCellID"
    let emptyCellID = "emptyCellID"
    var mainViewController: MainVC?
    var tableStyleWidth1: CGFloat = 20
    var tableStyleHeight1: CGFloat = 20
    var tableStyleWidth2: CGFloat = 20
    var tableStyleHeight2: CGFloat = 20
    let tableRows: CGFloat = 3.5
    let squareRows: CGFloat = 3
    
    func setUpCollectionView() {
        self.addSubview(recipeList)
        self.addSubview(tableStyle2)
        self.addSubview(tableStyle)
        tableStyle.tableStyle2 = self.tableStyle2
        tableStyle2.tableStyle = self.tableStyle
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: recipeList)
        
        tableStyleCenter = tableStyle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        tableStyleCenter?.isActive = true
        addConstraintsWithFormat(format: "V:|-[v1]-[v0]|", views: recipeList, tableStyle)
        
        tableStyleCenter2 = tableStyle2.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        tableStyleCenter2?.isActive = true
        addConstraintsWithFormat(format: "V:|-[v1]-[v0]|", views: recipeList, tableStyle2)
        
        recipeList.register(ListedRecipeCell.self, forCellWithReuseIdentifier: listedRecipeCellID)
        recipeList.register(SquareRecipeCell.self, forCellWithReuseIdentifier: squareRecipeCellID)
        recipeList.register(EmptyCell.self, forCellWithReuseIdentifier: emptyCellID)
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
        } else {
            return recipes?.count ?? 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if recipes!.count == 0 {
            toggleTableStyles(isHidden: true)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellID, for: indexPath)
            return cell
        } else {
            toggleTableStyles(isHidden: false)
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
    
    var cellWidth: CGSize?
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isList {
            cellWidth = CGSize(width: recipeList.frame.width - 16, height: recipeList.frame.height / tableRows)
        } else {
            cellWidth = CGSize(width: recipeList.frame.width/2, height: recipeList.frame.height / squareRows)
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
        guard let cell = collectionView.cellForItem(at: indexPath) as? ListedRecipeCell else { return }
        displayRecipeView(recipeCell: cell, index: indexPath.item, image: cell.recipeImage.image!)
        toggleTableStyles(isHidden: true)
    }
    
    lazy var recipeView: RecipeView = {
        let view = RecipeView()
        return view
    }()
    
    func toggleTableStyles(isHidden: Bool) {
        
        tableStyle.isHidden = isHidden
        tableStyle2.isHidden = isHidden
    }
    
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
        
        recipeView.mainViewController = self.mainViewController
        recipeView.recipe = recipes?[index]        
        recipeView.frame = self.bounds
        recipeView.alpha = 0
        
        //animate image into place?
        //"V:|-[v0(40)]-8-[v1]-6-[v2(75)]-86-|" + 4 + 4 FOR FRAMING
        
        let recipeFrameInset: CGFloat = 4
        
        //MOVING IMAGE INTO FOCUS
        UIView.animate(withDuration: 1.0, animations: {
            let yMovement = (self.frame.height - (self.frame.height - 8 - 40 - 8 - recipeFrameInset)) - image.frame.origin.y
            let endFrameHeight = self.frame.height - 8 - 40 - 8 - 6 - 75 - 86 - (recipeFrameInset * 2)
            
            var endFrameWidth: CGFloat!
            if self.isList {
                endFrameWidth = image.frame.width - (recipeFrameInset * 2)
                image.transform = CGAffineTransform(translationX: recipeFrameInset, y: yMovement)
            } else {
                endFrameWidth = self.frame.width - 8 - (recipeFrameInset * 2) - 8
                if index % 2 == 0 {
                    image.transform = CGAffineTransform(translationX: recipeFrameInset + 4, y: yMovement)
                } else {
                    image.transform = CGAffineTransform(translationX: -self.frame.width/2 + recipeFrameInset + 4, y: yMovement)
                }
            }
            
            image.frame.size = CGSize(width: endFrameWidth, height: endFrameHeight)
            self.recipeView.frame = self.bounds
            self.recipeList.alpha = 0
            self.recipeView.layoutSubviews()
        }, completion: { (_) in
            UIView.animate(withDuration: 1.0, animations: {
                self.recipeView.alpha = 1.0
            }, completion: { (_) in
                image.removeFromSuperview()
            })
        })
        
        image.animateCornerRadius(to: 10, duration: 2.0)
    }
}
