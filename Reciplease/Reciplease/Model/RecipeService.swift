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
    
    func getRecipes(callback: @escaping(Bool, Recipe?) -> Void) {
        let url = URL(string: "https://api.yummly.com/v1/api/recipes?_app_id=d2db4f54&_app_key=3d9d9071094ba629125874ebdfc836d8&requirePictures=true&allowedIngredient[]=tomato")!

        Alamofire.request(url).responseJSON { (response) in
            guard response.result.isSuccess,
                let data = response.data else {
                    callback(false, nil)
                    return
            }
            guard let recipesData = try? JSONDecoder().decode(RecipesResponse.self, from: data) else {
                callback(false, nil)
                return
            }
            
            let recipeName = recipesData.matches[0].data[0].recipeName
            let recipe = Recipe(recipeName: recipeName, ingredients: ["Tomatoes"], image: UIImage(named: "pizza")!)
            callback(true, recipe)
        }
    }
}

fileprivate struct RecipesResponse: Codable {
    let matches: [Matches]
}
fileprivate struct Matches: Codable {
    let data: [Data]
}
fileprivate struct Data: Codable {
    let recipeName: String
}




