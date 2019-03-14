//
//  IngredientsList.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 25/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation

struct IngredientsList {
    var all = [String]()
    
    func getAllowedIngredients() -> String {
        var allowedIngredients = String()
        
        for ingredient in all {
            allowedIngredients += "&allowedIngredient[]=\(ingredient)"
        }
        return allowedIngredients
    }
    
    mutating func append(_ ingredient: String) {
        var newIngredient = ingredient
        
        if newIngredient.first == " " {
            newIngredient.removeFirst()
            append(newIngredient)
        } else if newIngredient.last == " " {
            newIngredient.removeLast()
            append(newIngredient)
        } else if newIngredient == "" {
            return
        }else {
            all.append(newIngredient)
        }
    }
}
