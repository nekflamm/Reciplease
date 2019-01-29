//
//  RecipeService.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 25/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation
import Alamofire

class RecipeService {
    static let shared = RecipeService()
    
    func getRecipes(callback: @escaping(Bool, Recipe?) -> Void) {
        let url = URL(string: "https://api.yummly.com/v1/api/recipes?_app_id=d2db4f54&_app_key=3d9d9071094ba629125874ebdfc836d8&requirePictures=true&allowedIngredient[]=tomato")!

        Alamofire.request(url).responseJSON { (response) in
            guard response.result.isSuccess,
                let data = response.data else {
                    callback(false, nil)
                    return
            }
            do {
                self.getImage { (imageData) in
                    guard let imageData = imageData else {
                        callback(false, nil)
                        return
                    }
                    do {
                        let recipeData = try JSONDecoder().decode(RecipeResponse.self, from: data)
                        let recipeName = recipeData.matches[0].recipeName
                        let ingredients = recipeData.matches[0].ingredients
                        
                        let recipe = Recipe(recipeName: recipeName, ingredients: ingredients, image: imageData)
                        callback(true, recipe)
                    } catch {
                        print("error")
                    }
                }
            }
        }
    }
    
    private func getImage(completionHandler: @escaping ((Data?) -> Void)) {
        let url = URL(string: "https://lh3.googleusercontent.com/3dbNmfS4BI-7CUsm2WYE8l7-90CNi3rQPUkO5EMc0gts_MBUAVZlTngm-9VHshp9toXl73RKwiUs9JQCpx6RoQ=s400")!
        Alamofire.request(url).responseData { (response) in
            guard response.result.isSuccess,
                let data = response.data else {
                    completionHandler(nil)
                    return
            }
            completionHandler(data)
        }
    }
}

fileprivate struct RecipeResponse: Decodable {
    let matches: [Matches]
}

fileprivate struct Matches: Decodable {
    let recipeName: String
    let ingredients: [String]
    let totalTimeInSeconds: Int
    let rating: Int
    
    init(recipeName: String, ingredients: [String], totalTimeInSeconds: Int, rating: Int) {
        self.recipeName = recipeName
        self.ingredients = ingredients
        self.totalTimeInSeconds = totalTimeInSeconds
        self.rating = rating
    }
        
    enum MyStructKeys: String, CodingKey {
        case recipeName = "recipeName"
        case ingredients = "ingredients"
        case totalTimeInSeconds = "totalTimeInSeconds"
        case rating = "rating"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyStructKeys.self)
        let recipeName: String = try container.decode(String.self, forKey: .recipeName)
        let ingredients: [String] = try container.decode([String].self, forKey: .ingredients)
        let totalTimeInSeconds: Int = try container.decode(Int.self, forKey: .totalTimeInSeconds)
        let rating: Int = try container.decode(Int.self, forKey: .rating)
        
        self.init(recipeName: recipeName, ingredients: ingredients, totalTimeInSeconds: totalTimeInSeconds, rating: rating)
    }
}
