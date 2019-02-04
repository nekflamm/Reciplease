//
//  RecipeService.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 25/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class RecipeService {
    static let shared = RecipeService()
    
    func getRecipes(callback: @escaping(Bool) -> Void) {
        let allowedIngredients = IngredientsList.getAllowedIngredients()
        guard let url = URL(string: "https://api.yummly.com/v1/api/recipes?_app_id=d2db4f54&_app_key=3d9d9071094ba629125874ebdfc836d8&requirePictures=true\(allowedIngredients)&maxResult=30") else {
            callback(false)
            return
        }
        Alamofire.request(url).responseJSON { (response) in
            guard response.result.isSuccess,
                let data = response.data else {
                    callback(false)
                    return
            }
            guard let recipeData = try? JSONDecoder().decode(RecipeResponse.self, from: data) else {
                callback(false)
                return
            }
            self.storeRecipes(for: recipeData)
            callback(true)
        }
    }
    
    private func storeRecipes(for recipeData: RecipeResponse) {
        for recipe in recipeData.matches {
            let imageUrl = self.modifyUrl(recipe.smallImageUrls[0])

            self.getImage(for: imageUrl) { (image) in
                guard let image = image else {
                    return
                }
                let recipe = Recipe(name: recipe.name, ingredients: recipe.ingredients, image: image, rating: recipe.rating,
                                    timeInSeconds: recipe.totalTimeInSeconds, isFavorite: false)
                RecipesList.recipes.append(recipe)
            }
        }
    }
    
    private func getImage(for url: URL, completionHandler: @escaping ((UIImage?) -> Void)) {
        let url = url
        
        Alamofire.request(url).responseImage { (response) in
            guard response.result.isSuccess,
                let image = response.result.value else {
                    completionHandler(nil)
                    return
            }
            completionHandler(image)
        }
    }
    
    private func modifyUrl(_ imageUrl: String) -> URL {
        var stringUrl = imageUrl
        stringUrl.removeLast(2)
        stringUrl.append("300")
        
        guard let url = URL(string: stringUrl) else {
            return URL(string: "Error")!
        }
        return url
    }
}

fileprivate struct RecipeResponse: Decodable {
    let matches: [Matches]
}

fileprivate struct Matches: Decodable {
    let name: String
    let ingredients: [String]
    let totalTimeInSeconds: Int
    let rating: Int
    let smallImageUrls: [String]
    
    init(name: String, ingredients: [String], totalTimeInSeconds: Int, rating: Int, smallImageUrls: [String]) {
        self.name = name
        self.ingredients = ingredients
        self.totalTimeInSeconds = totalTimeInSeconds
        self.rating = rating
        self.smallImageUrls = smallImageUrls
    }
        
    enum MyStructKeys: String, CodingKey {
        case recipeName = "recipeName"
        case ingredients = "ingredients"
        case totalTimeInSeconds = "totalTimeInSeconds"
        case rating = "rating"
        case smallImageUrls = "smallImageUrls"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyStructKeys.self)
        let recipeName: String = try container.decode(String.self, forKey: .recipeName)
        let ingredients: [String] = try container.decode([String].self, forKey: .ingredients)
        let totalTimeInSeconds: Int = try container.decode(Int.self, forKey: .totalTimeInSeconds)
        let rating: Int = try container.decode(Int.self, forKey: .rating)
        let smallImageUrls: [String] = try container.decode([String].self, forKey: .smallImageUrls)
        
        self.init(name: recipeName, ingredients: ingredients, totalTimeInSeconds: totalTimeInSeconds,
                  rating: rating, smallImageUrls: smallImageUrls)
    }
}
