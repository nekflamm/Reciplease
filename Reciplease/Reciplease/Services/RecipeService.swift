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
    // -----------------------------------------------------------------
    //              MARK: - Properties
    // -----------------------------------------------------------------
    static let shared = RecipeService()
    
    private var appID: String {
        if let appID = Constants.APIKeys.all["AppID"] {
            return appID
        }
        
        return String()
    }
    
    private var appKey: String {
        if let appKey = Constants.APIKeys.all["AppKey"] {
            return appKey
        }
        
        return String()
    }
    
    // Number of recipes who can't be save
    var fails = 0
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    private init() {}
    
    func getRecipes(_ ingredients: String?, _ meal: String?, callback: @escaping(Bool, [Recipe]?, Int?) -> Void) {
        Alamofire.request(getIngredientsOrMealURL(ingredients, meal)).responseJSON { (response) in
            guard response.result.isSuccess,
                let data = response.data,
                let recipeData = try? JSONDecoder().decode(RecipeResponse.self, from: data) else {
                    callback(false, nil, nil)
                    return
            }
            
            let recipesNumber = recipeData.matches.count
            
            self.storeRecipes(for: recipeData) { (success, recipes)   in
                guard let recipes = recipes, success else {
                    callback(false, nil, nil)
                    return
                }
                
                callback(true, recipes, recipesNumber)
            }
        }
    }
    
    private func storeRecipes(for recipeData: RecipeResponse, callback: @escaping(Bool, [Recipe]?) -> Void) {
        if recipeData.matches.count != 0 {
            for recipe in recipeData.matches {
                if let url = recipe.smallImageUrls?[0], let time = recipe.totalTimeInSeconds {
                    let imageUrl = self.modifyUrl(url)
                    
                    self.getImage(for: imageUrl) { (image) in
                        guard let image = image else {
                            callback(false, nil)
                            return
                        }
                        
                        self.addRecipeToCentral(recipe, image, time)
                        
                        callback(true, RecipesList.shared.central)
                    }
                } else {
                    fails += 1
                }
            }
        } else {
            callback(false, nil)
        }
    }
    
    private func getImage(for url: URL, completionHandler: @escaping ((UIImage?) -> Void)) {
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
    
    private func getIngredientsOrMealURL(_ ingredients: String?, _ meal: String?) -> URL {
        var url = URL(string: "")
        
        if let ingredients = ingredients,
            let ingredientsURL = URL(string: "https://api.yummly.com/v1/api/recipes?_app_id=\(appID)&_app_key=\(appKey)&requirePictures=true\(ingredients)&maxResult=50") {
            url = ingredientsURL
        } else {
            if let meal = meal,
                let mealURL = URL(string: "https://api.yummly.com/v1/api/recipes?_app_id=\(appID)&_app_key=\(appKey)&requirePictures=true&q=\(meal)&maxResult=35") {
                url = mealURL
            }
        }
        
        return url!
    }
    
    func getUrl(for url: URL, callback: @escaping(Bool, URL?) -> Void) {
        Alamofire.request(url).responseJSON { (response) in
            guard response.result.isSuccess,
                let data = response.data else {
                    callback(false, nil)
                    return
            }
            
            guard let urlResponse = try? JSONDecoder().decode(URLResponse.self, from: data) else {
                callback(false, nil)
                return
            }
            
            let url = urlResponse.source.sourceRecipeUrl
            
            callback(true, url)
        }
    }
    
    func getIngredientsList(for ingredients: [String]) -> String {
        var string = String()
        for ingredient in ingredients {
            string += "\(ingredient), "
        }
        
        string.removeLast(2)
        return "\(string)."
    }
    
    func getTimeInMinute(for time: Int16) -> String {
        let timeInMinute = (time / 60)
        return "\(String(timeInMinute))m"
    }
    
    private func addRecipeToCentral(_ recipe: Infos, _ image: UIImage, _ time: Int) {
        let recipe = Recipe(name: recipe.recipeName, ingredients: recipe.ingredients, image: image, rating: recipe.rating,
                            timeInSeconds: time, id: recipe.id, url: nil, isFavorite: false)
        RecipesList.shared.central.append(recipe)
        print(RecipesList.shared.central.count)
    }
    
    func resetFails() {
        fails = 0
    }
}

// -----------------------------------------------------------------
//              MARK: - JSON Parsing
// -----------------------------------------------------------------
fileprivate struct RecipeResponse: Codable {
    let totalMatchCount: Int
    var matches: [Infos]
}

fileprivate struct Infos: Codable {
    let smallImageUrls: [String]?
    let ingredients: [String]
    let id: String
    let recipeName: String
    let totalTimeInSeconds: Int?
    let rating: Int
}

// Decode getUrl func response
fileprivate struct URLResponse: Codable {
    let source: Source
}
fileprivate struct Source: Codable {
    let sourceRecipeUrl: URL
    let sourceDisplayName: String
}
