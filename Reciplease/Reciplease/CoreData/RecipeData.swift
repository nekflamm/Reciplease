//
//  RecipeData.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 13/03/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RecipeData: NSManagedObject {
    // -----------------------------------------------------------------
    //              MARK: - Properties
    // -----------------------------------------------------------------
    static var all: [RecipeData] {
        let request: NSFetchRequest<RecipeData> = RecipeData.fetchRequest()
        guard let recipesData = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return recipesData
    }
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    static func dataToRecipe(for index: Int) -> Recipe? {
        let name = all[index].name
        let ingredients = all[index].ingredients
        let image = UIImage(data: all[index].image!)
        let id = all[index].id
        let rating = Int(all[index].rating)
        let time = Int(all[index].timeInSeconds)
        
        let recipe = Recipe(name: name!, ingredients: ingredients!, image: image!, rating: rating, timeInSeconds: time, id: id!, isFavorite: false)
        
        return recipe
    }
}
