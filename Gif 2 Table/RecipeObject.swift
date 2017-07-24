//
//  RecipeObject.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 4/22/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import Foundation
import UIKit

class RecipeObject: NSObject {
    
    //removed NSCoding which calls for func encode and convenience init coder aDecoder
    var recipeLink: String?
    var recipeTitle: String?
    var recipeImageLink: String?
    var recipeIngredients: [[String: String]]?
    var favorite: Bool?
    var isLiked: Bool?
    var isDisliked: Bool?
    var likes: Int?
    var dislikes: Int?
    var recipeChild: String?
    var mainVC: MainVC?
    var difficulty: Difficulty?
    var shouldfade: Bool = true
    var category: String?
    var downloadedImage: UIImage?
    
    init(link: String, title: String, imageLink: String, ingredients: [[String: String]], favorite: Bool, like: Bool, dislike: Bool, likes: Int, dislikes: Int, child: String, mainVC: MainVC?, category: String) {
        recipeLink = link
        recipeTitle = title
        recipeImageLink = imageLink
        recipeIngredients = ingredients
        self.favorite = favorite
        isLiked = like
        isDisliked = dislike
        self.likes = likes
        self.dislikes = dislikes
        recipeChild = child
        self.mainVC = mainVC
        self.category = category
        
        if ingredients.count <= 8 {
            self.difficulty = .easy
        } else if ingredients.count <= 15 {
            self.difficulty = .medium
        } else {
            self.difficulty = .hard
        }
    }
    
    
//    ENABLE IF USING UserDefaults
    
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(recipeLink, forKey: "recipeLink")
//        aCoder.encode(recipeTitle, forKey: "recipeTitle")
//        aCoder.encode(recipeImageLink, forKey: "recipeImageLink")
//        aCoder.encode(recipeIngredients, forKey: "recipeIngredients")
//        aCoder.encode(favorite, forKey: "favorite")
//        aCoder.encode(isLiked, forKey: "isLiked")
//        aCoder.encode(isDisliked, forKey: "isDisliked")
//    }
//    
//    convenience required init?(coder aDecoder: NSCoder) {
//        let recipeLink = aDecoder.decodeObject(forKey: "recipeLink") as? String
//        let recipeTitle = aDecoder.decodeObject(forKey: "recipeTitle") as? String
//        let recipeImageLink = aDecoder.decodeObject(forKey: "recipeImageLink") as? String
//        let recipeIngredients = aDecoder.decodeObject(forKey: "recipeIngredients") as? [[String: String]]
//        let favorite = aDecoder.decodeObject(forKey: "favorite") as? Bool
//        let isLiked = aDecoder.decodeObject(forKey: "isLiked") as? Bool
//        let isDisliked = aDecoder.decodeObject(forKey: "isDisliked") as? Bool
//        
//        self.init(link: recipeLink!, title: recipeTitle!, imageLink: recipeImageLink!, ingredients: recipeIngredients!, favorite: favorite!, like: isLiked!, dislike: isDisliked!)
//    }
    
    var passedImageURL: String?

}

extension RecipeObject {
    
    func downloadCoverImage(completion: @escaping (_ image: UIImage, _ title: String) -> () ) {
        
        let imageLink = self.recipeImageLink
        guard let imageURL = URL(string: imageLink!) else { return }
        passedImageURL = imageLink
        
        if let cachedImage = mainVC?.imageCache.object(forKey: imageLink as AnyObject) as? UIImage {
            DispatchQueue.main.async {
                completion(cachedImage, self.recipeTitle!)
                print("using cached image")
                return
            }
        } else {
            URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if self.passedImageURL == imageLink {                    
                    guard let coverImage = UIImage(data: data!) else { return }
                    self.mainVC?.imageCache.setObject(coverImage, forKey: imageLink as AnyObject)
                    
                    DispatchQueue.main.async {
                        completion(coverImage, self.recipeTitle!)
                        self.downloadedImage = coverImage
                        print("downloaded new image")
                    }
                }
            }.resume()
        }
    }
    
    // NOT IN USE.  
    // Alternative Cover Image Pull Using Image Data From URL.
    func downloadCoverImg(completion: @escaping (UIImage) -> ()) {
        if let imageLink = self.recipeImageLink {
            let imageURL = URL(string: imageLink)
            DispatchQueue.global().async {
                let imageData = try? Data(contentsOf: imageURL!)
                DispatchQueue.main.async {
                    guard let image = UIImage(data: imageData!) else { return }
                    completion(image)
                }
            }
        }
    }
    
}

struct IngredientObject {
    var name: String
    var imageName: String
    var measurement: String
}

enum Difficulty: String {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}
