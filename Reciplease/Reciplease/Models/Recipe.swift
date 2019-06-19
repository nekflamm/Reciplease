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
    
    var name: String
    var ingredients: [String]
    var image: UIImage
    var rating: Int
    var timeInSeconds: Int
    var id: String
    var isFavorite = false
    
    var ingredientsList: String {
        var list = ingredients.joined(separator: ", ")
        list.removeLast(2)
        
        return "\(list)."
    }
}

// Structs for JSON decoder
struct RecipeResponse: Decodable {
    let totalMatchCount: Int
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
