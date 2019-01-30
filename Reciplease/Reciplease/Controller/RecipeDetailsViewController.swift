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
        setupView()
    }
    
    @IBAction func addToFavoritesButton(_ sender: UIBarButtonItem) {
        guard let recipe = RecipesList.selectedRecipe else {
            return
        }
        Favorite.recipes.append(recipe)
        for recipe in Favorite.recipes {
            print(recipe.name)
        }
    }
    
    private func setupView() {
        guard let recipe = RecipesList.selectedRecipe else {
            return
        }
        let ingredients = convertToList(recipe.ingredients)
        recipeDetailsView.setup(title: recipe.name, ingredients: ingredients, image: recipe.image)
    }
    
    private func convertToList(_ ingredients: [String]) -> String {
        var ingredientsList = ""
        
        for ingredient in ingredients {
            ingredientsList += "• \(ingredient)\n\n"
        }
        return ingredientsList
    }
}
