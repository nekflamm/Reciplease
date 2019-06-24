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
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    private init() {}
    
    // Get a list of recipes from a list of ingredients
    func getRecipes(for searchParameters: String, callback: @escaping(Bool, [Recipe]?) -> Void) {
        let url = URL(string: "https://api.yummly.com/v1/api/recipes?_app_id=\(Constants.APIKeys.appID)&_app_key=\(Constants.APIKeys.appKey)&requirePictures=true&q=\(searchParameters)&maxResult=50")!
        
        Alamofire.request(url).responseJSON { (response) in
            guard response.result.isSuccess,
                let data = response.data,
                let recipesData = try? JSONDecoder().decode(RecipeResponse.self, from: data) else {
                    callback(false, nil)
                    return
            }
            
            callback(true, recipesData.matches)
        }
    }
    
    // Get a webPageUrl from a recipeID
    func getRecipeWebPageUrl(for id: String, callback: @escaping(Bool, URL?) -> Void) {
        let url = URL(string: "http://api.yummly.com/v1/api/recipe/\(id)?_app_id=\(Constants.APIKeys.appID)&_app_key=\(Constants.APIKeys.appKey)")!
        
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
}
