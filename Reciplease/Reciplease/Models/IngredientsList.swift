//
//  IngredientsList.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 25/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation

class IngredientsList {
    // -----------------------------------------------------------------
    //              MARK: - Properties
    // -----------------------------------------------------------------
    var all = [String]()
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    func getAllowedIngredients() -> String {
        var allowedIngredients = String()
        
        for ingredient in all {
            allowedIngredients += "&allowedIngredient[]=\(ingredient)"
        }
        return allowedIngredients
    }
    
    func append(_ ingredient: String) {
        let ingredientWithoutSpaces = ingredient.replacingOccurrences(of: " ", with: "+")
        
        if ingredientWithoutSpaces != "" {
            all.append(ingredientWithoutSpaces)
        }
    }
}
