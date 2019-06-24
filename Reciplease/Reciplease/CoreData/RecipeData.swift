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
        guard let name = all[index].name,
            let ingredients = all[index].ingredients,
            let imageURL = all[index].imageURL,
            let id = all[index].id else {
                
            return nil
        }
        
        return Recipe(recipeName: name, ingredients: ingredients, smallImageUrls: imageURL, rating: Int(all[index].rating), totalTimeInSeconds: Int(all[index].timeInSeconds), id: id)
    }
}
