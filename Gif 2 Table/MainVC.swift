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
        self.collectionView?.backgroundColor = .white
        downloadFeatureRecipe()
        downloadRecipeObjects()
        setUpCollectionView()
        setUpMenuBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isAppOpening {
            self.scrollToPage(itemNumber: 1)
            isAppOpening = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let window = view.window
//        for gesture in (window?.gestureRecognizers)! {
//            gesture.delaysTouchesBegan = false
//            print(gesture)
//        }
    }
    
    var isAppOpening = true
    let cellID = "sectionCell"
    let featureCellID = "featureCellID"
    let historyCellID = "historyCellID"
    let favoritesCellID = "favoritesCellID"
    let menuBarHeight: CGFloat = 50
    
    lazy var menuBar: MenuBar = {
        let bar = MenuBar()
        bar.mainViewController = self
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    var recipes: [RecipeObject] = [RecipeObject]()
    var featureRecipe: RecipeObject?
    
    //testing****
    func downloadRecipeObjects() {
        let recipe = RecipeObject(link: "https://thumbs.gfycat.com/PitifulConstantIsopod-mobile.mp4", title: "Bon Appetit Steak", imageLink: "http://assets.bonappetit.com/photos/57acdfb61b33404414975295/master/w_680,h_454,c_limit/dry-rubbed-flank-steak-with-grilled-corn-salsa.jpg", ingredients: ["Potato", "Salsa", "Tequila", "Corazon"], favorite: false)
        for _ in 0...5 {
            recipes.append(recipe)
        }
    }
    
    func downloadFeatureRecipe() {
        let recipe = RecipeObject(link: "https://thumbs.gfycat.com/PitifulConstantIsopod-mobile.mp4", title: "Bon Appetit Steak", imageLink: "http://assets.bonappetit.com/photos/57acdfb61b33404414975295/master/w_680,h_454,c_limit/dry-rubbed-flank-steak-with-grilled-corn-salsa.jpg", ingredients: ["Potato", "Salsa", "Tequila", "Corazon"], favorite: false)
        featureRecipe = recipe
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
                customCell.recipes = self.recipes.filter({$0.favorite == true})
                
                return customCell
            }
        } else if indexPath.item == 2 {
            if let customCell = cell(historyCellID) as? HistoryFavoritesCell {
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
}



