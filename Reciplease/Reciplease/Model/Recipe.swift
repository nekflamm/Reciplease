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
    var recipeName: String
    var ingredients: [String]
    var ingredientsList: String {
        var string = ""
        for ingredient in ingredients {
            string += "\(ingredient), "
        }
        return string
    }
    var image: UIImage
//    var note: Int
//    var timeInSeconds: Int
}

struct RecipesList {
    var recipes: [Recipe] {
        let recipe1 = Recipe(recipeName: "Recette de Meryl", ingredients: ["jambon", "fromages", "chevres", "bolognaise", "sel", "poivre", "basilic", "ratatouilles"], image: UIImage(named: "pizza")!)
        let recipe2 = Recipe(recipeName: "Recette de Adrien", ingredients: ["fromages", "tomates", "chevres", "bolognaise", "sel", "poivre", "basilic", "ratatouilles"], image: UIImage(named: "sushis")!)
        let recipe3 = Recipe(recipeName: "Recette de Thomas", ingredients: ["cheddar", "fromages", "chevres", "bolognaise", "sel", "poivre", "basilic", "ratatouilles"], image: UIImage(named: "couscous")!)
        let recipe4 = Recipe(recipeName: "Recette de Paul", ingredients: ["saussisses", "fromages", "chevres", "bolognaise", "sel", "poivre", "basilic", "ratatouilles"], image: UIImage(named: "fruits")!)
        let recipe5 = Recipe(recipeName: "Recette de Michel", ingredients: ["creme", "fromages", "chevres", "bolognaise", "sel", "poivre", "basilic", "ratatouilles"], image: UIImage(named: "poivrons")!)
        let recipe6 = Recipe(recipeName: "Recette de Meryl", ingredients: ["jambon", "fromages", "chevres", "bolognaise", "sel", "poivre", "basilic", "ratatouilles"], image: UIImage(named: "pizza")!)
        let recipe7 = Recipe(recipeName: "Recette de Adrien", ingredients: ["fromages", "tomates", "chevres", "bolognaise", "sel", "poivre", "basilic", "ratatouilles"], image: UIImage(named: "sushis")!)
        let recipe8 = Recipe(recipeName: "Recette de Thomas", ingredients: ["cheddar", "fromages", "chevres", "bolognaise", "sel", "poivre", "basilic", "ratatouilles"], image: UIImage(named: "couscous")!)
        let recipe9 = Recipe(recipeName: "Recette de Paul", ingredients: ["saussisses", "fromages", "chevres", "bolognaise", "sel", "poivre", "basilic", "ratatouilles"], image: UIImage(named: "fruits")!)
        let recipe10 = Recipe(recipeName: "Recette de Michel", ingredients: ["creme", "fromages", "chevres", "bolognaise", "sel", "poivre", "basilic", "ratatouilles"], image: UIImage(named: "poivrons")!)
        
        return [recipe1, recipe2, recipe3, recipe4, recipe5, recipe6, recipe7, recipe8, recipe9, recipe10]
    }
    
    static var selectedRecipe: Recipe?
}

