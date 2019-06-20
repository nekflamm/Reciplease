//
//  RecipesManager.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 19/06/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation
import UIKit

class RecipesManager {
    // -----------------------------------------------------------------
    //              MARK: - Properties
    // -----------------------------------------------------------------
    private var recipes = [String: [Recipe]]()
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    func fillRecipes(forKey key: String, with recipes: [Recipe]) {
        self.recipes[key]?.removeAll()
        self.recipes[key] = recipes
    }
    
    func convertDataToRecipes(withData recipesData: [RecipeInfos], and images: [UIImage]) -> [Recipe] {
        return recipesData.enumerated().map { Recipe(name: $1.recipeName, ingredients: $1.ingredients, image: images[$0], rating: $1.rating, timeInSeconds: $1.totalTimeInSeconds ?? 00, id: $1.id, isFavorite: false) }
    }
    
    func getRecipes(forKey key: String) -> [Recipe]? {
        return recipes[key]
    }
}
