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
    private var recipes = [Recipe]()
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    
    func fillRecipe(with recipe: Recipe) {
        recipes.append(recipe)
    }
    
    func removeRecipes() {
        recipes.removeAll()
    }
    
    func convertDataToRecipe(withData recipeData: RecipeInfos, and image: UIImage) -> Recipe {
        return Recipe(name: recipeData.recipeName, ingredients: recipeData.ingredients, image: image, rating: recipeData.rating, timeInSeconds: recipeData.totalTimeInSeconds ?? 00, id: recipeData.id, isFavorite: false)
    }

    func getRecipes() -> [Recipe]? {
        return recipes
    }
}
