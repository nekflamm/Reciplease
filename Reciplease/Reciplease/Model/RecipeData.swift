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
    static func dataToRecipe(for indexPath: Int) -> Recipe? {
        let name = all[indexPath].name
        let ingredients = all[indexPath].ingredients
        let image = UIImage(data: all[indexPath].image!)
        let id = all[indexPath].id
        let url = all[indexPath].url
        let rating = Int(all[indexPath].rating)
        let time = Int(all[indexPath].timeInSeconds)
        
        let recipe = Recipe(name: name!, ingredients: ingredients!, image: image!, rating: rating, timeInSeconds: time, id: id!, url: url, isFavorite: false)
        
        return recipe
    }
}
