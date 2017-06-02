//
//  MainVC.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 4/21/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class MainVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = .clear
        navigationItem.title = "GIF 2 Table"
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: fontLuna?.withSize(18), NSForegroundColorAttributeName: UIColor.white]
        
        loadData()
        
        establishScrollProperties()
        
        updateIngredientList()
        
        downloadRecipeObjects()
        
        downloadFeatureRecipe()
        
        setUpCollectionView()
        
        setUpMenuBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isAppOpening {
            self.scrollToPage(itemNumber: 1)
            isAppOpening = false
        }
    }
    
    var isAppOpening = true
    let cellID = "sectionCell"
    let featureCellID = "featureCellID"
    let historyCellID = "historyCellID"
    let favoritesCellID = "favoritesCellID"
    let menuBarHeight: CGFloat = 60
    var backgroundImg: CustomBackground?
    // for controlling opacity of each section
    let animateOpacityStart: CGFloat = 0.2
    var viewWidth: CGFloat?
    var pageXReference: CGFloat?
    // for controlling background shift
    var centerOffset: CGFloat?
    
    lazy var menuBar: MenuBar = {
        let bar = MenuBar()
        bar.mainViewController = self
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    var recipes: [RecipeObject] = [RecipeObject]()
    var featureRecipe: RecipeObject?
    var featureRecipeStored: RecipeObject?
    var favoriteRecipes = [RecipeObject]() {
        didSet {
            print("main vc favorite recipes modified")
        }
    }
    var likedRecipes = [RecipeObject]()
    var dislikedRecipes = [RecipeObject]()
    
    var historyListSwitch = false
    
    //testing****
    func downloadRecipeObjects() {
        let firebaseMgr = Firebase()
        firebaseMgr.downloadData { (recipes) in
            self.recipes = recipes
            print("download completed")
        }
    }
    
    fileprivate func downloadFeatureRecipe() {
        
        // turn this into a dummy recipe
        let recipe = RecipeObject(link: " ", title: " ", imageLink: " ", ingredients: [[:]], favorite: false, like: false, dislike: false, likes: 0, dislikes: 0, child: "Recipe0")
        featureRecipe = recipe
        featureRecipeStored = recipe
        
        let firebaseMgr = Firebase()
        firebaseMgr.downloadData { (recipes) in
            self.featureRecipe = recipes.first
            self.featureRecipeStored = recipes.first
            self.collectionView?.reloadData()
        }
    }
    
    fileprivate func updateIngredientList() {
        let firebaseMgr = Firebase()
        firebaseMgr.updateIngredients { (updatedIngredientList) in
            ingredientDictionary = updatedIngredientList
        }
    }
    //testing****
    
    func setUpCollectionView() {
        
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        collectionView?.isPagingEnabled = true
        collectionView?.alwaysBounceHorizontal = true
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(FeatureCell.self, forCellWithReuseIdentifier: featureCellID)
        collectionView?.register(HistoryFavoritesCell.self, forCellWithReuseIdentifier: historyCellID)
        collectionView?.register(HistoryFavoritesCell.self, forCellWithReuseIdentifier: favoritesCellID)
        
        collectionView?.contentInset = UIEdgeInsetsMake(menuBarHeight, 0, 0, 0)
    }
    
    fileprivate func setUpMenuBar() {
        self.view.addSubview(menuBar)
        
        menuBar.selectItem(at: IndexPath(item: 1, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        menuBar.heightAnchor.constraint(equalToConstant: menuBarHeight).isActive = true
        menuBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        menuBar.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    }
            
    func scrollToPage(itemNumber: Int) {
        let indexPath = IndexPath(item: itemNumber, section: 0)
        self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = {(identifier: String) -> UICollectionViewCell in
            let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
            return customCell
        }
        
        var customCell: UICollectionViewCell?
        
        let backColors: [UIColor] = [.yellow, .black, .gray]
        
        if indexPath.item == 1 {
            if let customCell = cell(featureCellID) as? FeatureCell {
                customCell.cellMainViewController = self
                customCell.recipeView.recipe = self.featureRecipe
                return customCell
            }
        } else if indexPath.item == 0 {
            if let customCell = cell(favoritesCellID) as? HistoryFavoritesCell {
                customCell.mainViewController = self
                customCell.recipes = self.favoriteRecipes
                
                return customCell
            }
        } else if indexPath.item == 2 {
            if let customCell = cell(historyCellID) as? HistoryFavoritesCell {
                customCell.isList = historyListSwitch
                customCell.mainViewController = self
                customCell.recipes = self.recipes
                
                return customCell
            }
        }else {
            customCell = cell(cellID)
        }
        
        customCell?.backgroundColor = backColors[indexPath.item]
        
        return customCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - menuBarHeight)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = targetContentOffset.pointee.x / view.frame.width
        menuBar.selectItem(at: IndexPath(item: Int(pageNumber), section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
    }
    
    fileprivate func loadData() {
        let coreDataManager = CoreDataManager()
        self.favoriteRecipes = coreDataManager.loadData(entityName: "RecipeModel")
        self.likedRecipes = coreDataManager.loadData(entityName: "LikedRecipe")
        self.dislikedRecipes = coreDataManager.loadData(entityName: "DislikedRecipe")
        print("liked count: \(likedRecipes.count)")
        print("disliked count: \(dislikedRecipes.count)")
    }
}

