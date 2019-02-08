//
//  RecipesList.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 04/02/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation

struct RecipesList {
    static var shared = RecipesList()
    var central = [Recipe]()
    var recipes = [Recipe]()
    var favorites = [Recipe]()
    var todaysRecipes = [Recipe]()
    var selectedRecipe: Recipe?
    var index = 0
    
    mutating func emptyCentral() {
        central.removeAll()
    }
}
