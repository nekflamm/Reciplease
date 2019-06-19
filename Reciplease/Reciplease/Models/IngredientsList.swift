//
//  IngredientsList.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 25/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation

class IngredientsList {
    
    var all = [String]()
    
    func append(_ ingredient: String) {
        let trimedSpacesIngredient = ingredient.trimmingCharacters(in: .whitespacesAndNewlines)
        let ingredientWithReplacedSpaces = trimedSpacesIngredient.replacingOccurrences(of: " ", with: "+")
        
        if ingredientWithReplacedSpaces != "" {
            all.append(ingredientWithReplacedSpaces)
        }
    }
    
    func getAllowedIngredients() -> String {
        return all.map { "&allowedIngredient[]=\($0)" }.joined()
    }
}
