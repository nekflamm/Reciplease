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
    var ingredientsList: String {
        var string = ""
        for ingredient in ingredients {
            string += "\(ingredient), "
        }
        string.removeLast(2)
        return "\(string)."
    }
    var image: UIImage
    var rating: Int
    var ratingToString: String {
        return String(rating)
    }
    var timeInSeconds: Int
    var timeToString: String {
        let timeInMinute = (timeInSeconds / 60)
        return "\(String(timeInMinute))m"
    }
}

struct RecipesList: List {
    static var recipes = [Recipe]()
    static var selectedRecipe: Recipe?
}

