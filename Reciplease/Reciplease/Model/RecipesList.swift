//
//  RecipesList.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 04/02/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation

struct RecipesList: List {
    static var recipes = [Recipe]()
    static var selectedRecipe: Recipe?
    static var index = 0
}
