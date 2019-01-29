//
//  RecipeDetailsViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 24/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    @IBOutlet weak var recipeDetailsView: RecipeDetailsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passDataToSetup()
    }
    
    @IBAction func addToFavoritesButton(_ sender: UIBarButtonItem) {
        print("Add recipe to favorites")
    }
    
    private func passDataToSetup() {
        guard let recipe = RecipesList.selectedRecipe else {
            return
        }
//        recipeDetailsView.setup(title: recipe.recipeName, ingredients: convertToString(recipe.ingredients), image: recipe.image)
    }
    
    private func convertToString(_ ingredients: [String]) -> String {
        var ingredientsList = ""
        
        for ingredient in ingredients {
            ingredientsList += "• \(ingredient)\n\n"
        }
        return ingredientsList
    }
}
