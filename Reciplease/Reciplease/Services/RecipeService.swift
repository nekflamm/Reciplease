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
