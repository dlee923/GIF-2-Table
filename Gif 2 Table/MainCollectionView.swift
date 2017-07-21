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
    let recipesPerView: CGFloat = 3.5
    let featureCellHeight: CGFloat = 0.2
    let collectionViewSideBorders: CGFloat = 10
    var isFavorites = false
    var isFilteredByFood = false
    
    var filterCategoryTitle: String?
    
    let mainRecipeCell = "mainRecipeCell"
    let mainHeaderCell = "mainHeaderCell"
    let mainFeatureCell = "mainFeatureCell"
    let emptyCell = "emptyCell"
    
    var maxVisibleRecipes = 5 {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    let additionalRecipeIncremental = 3
    
    fileprivate func setUpCollectionView() {
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.register(MainRecipeCell.self, forCellWithReuseIdentifier: mainRecipeCell)
        self.collectionView?.register(MainFeatureCell.self, forCellWithReuseIdentifier: mainFeatureCell)
        self.collectionView?.register(EmptyCell.self, forCellWithReuseIdentifier: emptyCell)
        self.collectionView?.register(MainHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: mainHeaderCell)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isFavorites || isFilteredByFood {
            return 1
        } else {
            return 2
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if recipes == nil || recipes?.count == 0 {
            return 1
        }
        
        if let recipeCount = recipes?.count {

            if isFavorites || isFilteredByFood {
                return recipeCount > self.maxVisibleRecipes ? maxVisibleRecipes : recipeCount
            }

            print("recipe count is \(recipeCount)")
            switch section {
            case 0:
                return 1
            case 1:
                return recipeCount > maxVisibleRecipes ? maxVisibleRecipes : recipeCount
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
            let emptyCellSize = CGSize(width: main.view.frame.width - (collectionViewSideBorders * 2), height: main.view.frame.height * featureCellHeight)
            
            if recipes == nil || recipes?.count == 0 {
                return emptyCellSize
            } else if isFavorites || isFilteredByFood {
                return normalCellSize
            } else {
                switch indexPath.section {
                case 0: return featuredCellSize
                case 1: return normalCellSize
                default: break
                }
            }
        }
        return CGSize.zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellStyleForSection section: Int) -> MDCCollectionViewCellStyle {
        return .card
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: mainHeaderCell, for: indexPath) as? MainHeaderCell {
            
            header.collectionViewSideSpacing = self.collectionViewSideBorders
            
            if isFavorites {
                header.headerLabel.text = "FAVORITE RECIPES"
            } else if isFilteredByFood {
                header.headerLabel.text = filterCategoryTitle
            } else {
                switch indexPath.section {
                case 0: header.headerLabel.text = "FEATURE RECIPES"
                case 1: header.headerLabel.text = "LATEST"
                default: break
                }
            }
            return header
        }
        
        return MainHeaderCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCell, for: indexPath) as? EmptyCell else {
            return UICollectionViewCell()
        }
        
        guard let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: mainRecipeCell, for: indexPath) as? MainRecipeCell else {
            return UICollectionViewCell()
        }
        
        if isFavorites || isFilteredByFood {
            if recipes == nil || self.recipes?.count == 0{
                if isFavorites {
                    emptyCell.setUpEmptyPrompt(type: .noFavorites)
                } else if isFilteredByFood {
                    emptyCell.setUpEmptyPrompt(type: .noCategoryType)
                }
                return emptyCell
            } else {
                mainCell.recipe = self.recipes?[indexPath.item]
                mainCell.recipeCardFrame = mainCell.frame
                mainCell.mainVC = self.mainVC
                
                mainCell.recipeImage.contentMode = .scaleAspectFit
                mainCell.recipeImage.image = UIImage(named: "g2tplaceholder")?.withRenderingMode(.alwaysTemplate)
                
                mainCell.thumbsUp.isSelected = false
                mainCell.thumbsDown.isSelected = false
                mainCell.loveButton.isSelected = false
                
                mainCell.thumbsUp.checkIfLiked()
                mainCell.thumbsDown.checkIfDisliked()
                mainCell.loveButton.checkIfFavorite()
                
                return mainCell
            }
        }
        
        if recipes == nil || recipes?.count == 0{
            emptyCell.setUpEmptyPrompt(type: .noRecipes)
            return emptyCell
        } else if indexPath.section == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainFeatureCell, for: indexPath) as? MainFeatureCell {
                cell.recipes = self.recipes
                cell.mainVC = self.mainVC
                return cell
            }
        } else if indexPath.section == 1 {
            mainCell.recipe = self.recipes?[indexPath.item]
            mainCell.recipeCardFrame = mainCell.frame
            mainCell.mainVC = self.mainVC
            
            mainCell.recipeImage.contentMode = .scaleAspectFit
            mainCell.recipeImage.image = UIImage(named: "g2tplaceholder")?.withRenderingMode(.alwaysTemplate)
            
            mainCell.thumbsUp.isSelected = false
            mainCell.thumbsDown.isSelected = false
            mainCell.loveButton.isSelected = false
            
            mainCell.thumbsUp.checkIfLiked()
            mainCell.thumbsDown.checkIfDisliked()
            mainCell.loveButton.checkIfFavorite()
            
            return mainCell
        }

        return UICollectionViewCell()
    }
    
    var recipeView: RecipeView?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if recipes == nil || recipes?.count == 0 {
            return
        }
        if indexPath.section == 1 || isFavorites || isFilteredByFood {
            if let window = UIApplication.shared.keyWindow {
                recipeView = RecipeView(frame: window.bounds)
                if let _recipeView = recipeView {
                    _recipeView.recipe = recipes?[indexPath.item]
                    _recipeView.mainVC = self.mainVC
                    _recipeView.recipeCell = self.collectionView?.cellForItem(at: indexPath) as? MainRecipeCell
                    window.addSubview(_recipeView)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
