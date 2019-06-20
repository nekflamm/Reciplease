//
//  Recipe.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 25/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation
import UIKit

struct Recipe {
    // -----------------------------------------------------------------
    //              MARK: - Properties
    // -----------------------------------------------------------------
    var name: String
    var ingredients: [String]
    var image: UIImage
    var rating: Int
    var timeInSeconds: Int
    var id: String
    var isFavorite = false
    
    var followingIngredients: String {
        var followingIngredients = ingredients.joined(separator: ", ")
        followingIngredients.removeLast(2)
        
        return "\(followingIngredients)."
    }
    
    var ingredientsToList: String {
        return ingredients.map { "• \($0)\n\n" }.joined()
    }
}

// Decodable structs to decode recipes response
struct RecipeResponse: Decodable {
    var matches: [RecipeInfos]
}

struct RecipeInfos: Decodable {
    let smallImageUrls: [String]?
    let ingredients: [String]
    let id: String
    let recipeName: String
    let totalTimeInSeconds: Int?
    let rating: Int
}
