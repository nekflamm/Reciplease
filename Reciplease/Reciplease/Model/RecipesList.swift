//
//  RecipesList.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 04/02/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation

struct RecipesList {
    // -----------------------------------------------------------------
    //              MARK: - Properties
    // -----------------------------------------------------------------
    static var shared = RecipesList()
    var central = [Recipe]()
    var recipes = [Recipe]()
    var favorites = [Recipe]()
    var todaysRecipes = [Recipe]()
    var selectedRecipes = [String: Recipe]()
    var key = "search"
    var index = 0
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    private init() {}
    
    mutating func emptyCentral() {
        central.removeAll()
    }
    
//    func checkRecipes(for recipe: Recipe, in array: [Recipe]) -> Int? {
//        var index = 0
//        
//        for recipe in array {
//            if recipe.image == recipe.image {
//                return index
//            }
//            index += 1
//        }
//        return nil
//    }
}
