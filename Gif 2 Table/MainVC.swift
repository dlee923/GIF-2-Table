//
//  MainVC.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 4/21/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = globalBackgroundColor
        self.navigationItem.titleView = titleView
        
        loadData()

        downloadRecipeObjects()
        
        setUpCollectionView()
    }
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    lazy var titleView: TitleView = {
        let _titleView = TitleView()
        _titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        _titleView.mainVC = self
        return _titleView
    }()
    
    lazy var mainCollectionView: MainCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let _mainCollectionView = MainCollectionView(collectionViewLayout: layout)
        
        _mainCollectionView.mainVC = self
        return _mainCollectionView
    }()
    
    var recipes: [RecipeObject] = [RecipeObject]() {
        didSet {
            mainCollectionView.recipes = self.recipes
        }
    }
    var featureRecipe: RecipeObject?
    var featureRecipeStored: RecipeObject?
    var favoriteRecipes = [RecipeObject]()
    var likedRecipes = [RecipeObject]()
    var dislikedRecipes = [RecipeObject]()
    
    fileprivate func setUpCollectionView() {
        guard let _mainCollectionView = mainCollectionView.collectionView else { return }
        self.view.addSubview(_mainCollectionView)
        
        _mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        _mainCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        _mainCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        _mainCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        _mainCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

    fileprivate func downloadRecipeObjects() {
        let firebaseMgr = Firebase()
        firebaseMgr.mainVC = self
        firebaseMgr.downloadData { (recipes) in
//            self.recipes = recipes
            self.recipes = Array(recipes.prefix(2))
            self.featureRecipe = recipes.first
            self.featureRecipeStored = recipes.first
            
            self.mainCollectionView.collectionView?.reloadData()
            print("download completed")
        }
    }
    
    fileprivate func loadData() {
        let coreDataManager = CoreDataManager()
        coreDataManager.mainVC = self
        self.favoriteRecipes = coreDataManager.loadData(entityName: "RecipeModel")
        self.likedRecipes = coreDataManager.loadData(entityName: "LikedRecipe")
        self.dislikedRecipes = coreDataManager.loadData(entityName: "DislikedRecipe")
        print("liked count: \(likedRecipes.count)")
        print("disliked count: \(dislikedRecipes.count)")
    }
    
}

