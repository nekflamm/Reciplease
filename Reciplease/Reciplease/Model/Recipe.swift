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
    var recipeName = ["Recette de Meryl", "Lardons chèvre", "Tomates", "Recette de grand mère", "Pizzas", "Couscous"]
    var ingredients: [String] = ["Tomato", "Lemon", "Brocoli", "Meat", "Sausages"]
    var ingredientsList: String {
        var string = ""
        for ingredient in ingredients {
            string += "\(ingredient), "
        }
        return string
    }
    var note: Int = 4
    var timeInSeconds: Int = 2000
    var image = [UIImage(named: "pizza"), UIImage(named: "couscous"),
                          UIImage(named: "sushis"), UIImage(named: "pates"),
                          UIImage(named: "poivrons"), UIImage(named: "fruits")]
    var index = [0, 1, 2, 3, 4, 5]
}

struct RecipesList {
    let recipe = Recipe()
}

