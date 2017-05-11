//
//  RecipeObject.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 4/22/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import Foundation
import UIKit

class RecipeObject: NSObject, NSCoding {
    
    var recipeLink: String?
    var recipeTitle: String?
    var recipeImageLink: String?
    var recipeIngredients: [String]?
    var favorite: Bool?
    var isLiked: Bool?
    var isDisliked: Bool?
    
    init(link: String, title: String, imageLink: String, ingredients: [String], favorite: Bool, like: Bool, dislike: Bool) {
        recipeLink = link
        recipeTitle = title
        recipeImageLink = imageLink
        recipeIngredients = ingredients
        self.favorite = favorite
        isLiked = like
        isDisliked = dislike
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(recipeLink, forKey: "recipeLink")
        aCoder.encode(recipeTitle, forKey: "recipeTitle")
        aCoder.encode(recipeImageLink, forKey: "recipeImageLink")
        aCoder.encode(recipeIngredients, forKey: "recipeIngredients")
        aCoder.encode(favorite, forKey: "favorite")
        aCoder.encode(isLiked, forKey: "isLiked")
        aCoder.encode(isDisliked, forKey: "isDisliked")
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        let recipeLink = aDecoder.decodeObject(forKey: "recipeLink") as? String
        let recipeTitle = aDecoder.decodeObject(forKey: "recipeTitle") as? String
        let recipeImageLink = aDecoder.decodeObject(forKey: "recipeImageLink") as? String
        let recipeIngredients = aDecoder.decodeObject(forKey: "recipeIngredients") as? [String]
        let favorite = aDecoder.decodeObject(forKey: "favorite") as? Bool
        let isLiked = aDecoder.decodeObject(forKey: "isLiked") as? Bool
        let isDisliked = aDecoder.decodeObject(forKey: "isDisliked") as? Bool
        
        self.init(link: recipeLink!, title: recipeTitle!, imageLink: recipeImageLink!, ingredients: recipeIngredients!, favorite: favorite!, like: isLiked!, dislike: isDisliked!)
    }

}

extension RecipeObject {
    
    func downloadCoverImage(completion: @escaping (UIImage) -> () ) {
        let imageLink = self.recipeImageLink
        let imageURL = URL(string: imageLink!)
        
        URLSession.shared.dataTask(with: imageURL!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            guard let coverImage = UIImage(data: data!) else { return }
            
            DispatchQueue.main.async {
                completion(coverImage)
            }
        }.resume()
    }
    
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
