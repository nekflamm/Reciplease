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
        var recipes = [Recipe]()
        
        for (i, data) in recipesData.enumerated() {
            recipes.append(Recipe(name: data.recipeName, ingredients: data.ingredients, image: images[i], rating: data.rating, timeInSeconds: data.totalTimeInSeconds ?? 00, id: data.id, isFavorite: false))
        }
        
        return recipes
    }
    
    func getRecipes(forKey key: String) -> [Recipe]? {
        return recipes[key]
    }
}
