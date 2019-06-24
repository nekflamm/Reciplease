//
//  Recipe.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 25/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation
import UIKit

struct RecipeResponse: Decodable {
    var matches: [Recipe]
}

struct Recipe: Decodable {
    let recipeName: String
    let ingredients: [String]
    let smallImageUrls: [String]?
    let rating: Int
    let totalTimeInSeconds: Int?
    let id: String
    
    var followingIngredients: String {
        var followingIngredients = ingredients.joined(separator: ", ")
        followingIngredients.removeLast(2)
        
        return "\(followingIngredients)."
    }
    
    var ingredientsToList: String {
        return ingredients.map { "• \($0)\n\n" }.joined()
    }
}
