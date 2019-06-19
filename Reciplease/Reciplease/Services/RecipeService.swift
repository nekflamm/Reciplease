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
    
    private init() {}
    
    func getRecipes(_ ingredients: String?, _ meal: String?, callback: @escaping(Bool, [RecipeInfos]?) -> Void) {
        Alamofire.request(getIngredientsOrMealURL(ingredients, meal)).responseJSON { (response) in
            guard response.result.isSuccess,
                let data = response.data,
                let recipesData = try? JSONDecoder().decode(RecipeResponse.self, from: data) else {
                    callback(false, nil)
                    return
            }

            callback(true, recipesData.matches)
        }
    }
    
    func getImage(for url: URL, callback: @escaping ((UIImage?) -> Void)) {
        Alamofire.request(url).responseImage { (response) in
            guard response.result.isSuccess,
                let image = response.result.value else {
                    callback(nil)
                    return
            }
            
            callback(image)
        }
    }
    
    func getWebPageUrl(for url: URL, callback: @escaping(Bool, URL?) -> Void) {
        Alamofire.request(url).responseJSON { (response) in
            guard response.result.isSuccess,
                let data = response.data,
                let urlResponse = try? JSONDecoder().decode(URLResponse.self, from: data) else {
                    callback(false, nil)
                    return
            }
            
            callback(true, urlResponse.source.sourceRecipeUrl)
        }
    }
    
    private func getIngredientsOrMealURL(_ ingredients: String?, _ meal: String?) -> URL {
        var url = URL(string: "")
        
        if let ingredients = ingredients,
            let ingredientsURL = URL(string: "https://api.yummly.com/v1/api/recipes?_app_id=\(Constants.APIKeys.appID)&_app_key=\(Constants.APIKeys.appKey)&requirePictures=true\(ingredients)&maxResult=50") {
            url = ingredientsURL
        } else {
            if let meal = meal,
                let mealURL = URL(string: "https://api.yummly.com/v1/api/recipes?_app_id=\(Constants.APIKeys.appID)&_app_key=\(Constants.APIKeys.appKey)&requirePictures=true&q=\(meal)&maxResult=35") {
                url = mealURL
            }
        }
        
        return url!
    }
}

// Decode getWebPageUrl func response
fileprivate struct URLResponse: Decodable {
    let source: Source
}
fileprivate struct Source: Decodable {
    let sourceRecipeUrl: URL
    let sourceDisplayName: String
}






//    private func addRecipeToCentral(_ recipe: RecipeInfos, _ image: UIImage, _ time: Int) {
//        let recipe = Recipe(name: recipe.recipeName, ingredients: recipe.ingredients, image: image, rating: recipe.rating,
//                            timeInSeconds: time, id: recipe.id, isFavorite: false)
//
//        RecipesList.shared.central.append(recipe)
//
////        print(RecipesList.shared.central.count)
//    }
//
//    func resetFails() {
//        fails = 0
//    }

//    private func modifyUrl(_ imageUrl: String) -> URL {
//        var stringUrl = imageUrl
//        stringUrl.removeLast(2)
//        stringUrl.append("300")
//
//        guard let url = URL(string: stringUrl) else {
//            return URL(string: "Error")!
//        }
//
//        return url
//    }

//    func getRecipes(_ ingredients: String?, _ meal: String?, callback: @escaping(Bool, [Recipe]?, Int?) -> Void) {
//        print("Enter in getRecipes")
//        Alamofire.request(getIngredientsOrMealURL(ingredients, meal)).responseJSON { (response) in
//            print("Enter in alamo call")
//            guard response.result.isSuccess,
//                let data = response.data,
//                let recipeData = try? JSONDecoder().decode(RecipeResponse.self, from: data) else {
//                    callback(false, nil, nil)
//                    return
//            }
//
//            print("Recipes number:")
//            print(recipeData.matches.count)
//
//            self.storeRecipes(for: recipeData) { (success, recipes)   in
//                print("Calling storeRecipes")
//                guard let recipes = recipes, success else {
//                    callback(false, nil, nil)
//                    return
//                }
//
//                callback(true, recipes, recipeData.matches.count)
//            }
//        }
//    }
//
//    private func storeRecipes(for recipeData: RecipeResponse, callback: @escaping(Bool, [Recipe]?) -> Void) {
//        if recipeData.matches.count != 0 {
//            for recipe in recipeData.matches {
//                if let url = recipe.smallImageUrls?[0], let time = recipe.totalTimeInSeconds {
//                    let imageUrl = self.modifyUrl(url)
//
//                    self.getImage(for: imageUrl) { (image) in
//                        guard let image = image else {
//                            callback(false, nil)
//                            return
//                        }
//
//                        self.addRecipeToCentral(recipe, image, time)
//
//                        callback(true, RecipesList.shared.central)
//                    }
//                } else {
//                    fails += 1
//                }
//            }
//        } else {
//            callback(false, nil)
//        }
//    }
