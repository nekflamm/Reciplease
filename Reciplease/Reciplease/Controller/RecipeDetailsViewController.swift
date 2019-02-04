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
    @IBOutlet weak var favoriteButtonOutlet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction func addToFavoritesButton(_ sender: UIBarButtonItem) {
        if RecipesList.recipes[RecipesList.index].isFavorite {
            RecipesList.recipes[RecipesList.index].isFavorite = false
            changeNavigationItemColorFor(UIColor.white)
        } else {
            RecipesList.recipes[RecipesList.index].isFavorite = true
            changeNavigationItemColorFor(UIColor.orange)
        }
    }
    
    private func setupView() {
        guard let recipe = RecipesList.selectedRecipe else {
            return
        }
        let ingredients = convertToList(recipe.ingredients)
        recipeDetailsView.setup(title: recipe.name, ingredients: ingredients, image: recipe.image, rate: recipe.ratingToString, time: recipe.timeToString)
    }
    
    private func convertToList(_ ingredients: [String]) -> String {
        var ingredientsList = ""
        
        for ingredient in ingredients {
            ingredientsList += "• \(ingredient)\n\n"
        }
        return ingredientsList
    }
    
    private func changeNavigationItemColorFor(_ color: UIColor) {
        favoriteButtonOutlet.tintColor = color
    }
    
    private func addRecipe(_ recipe: Recipe) {
        changeNavigationItemColorFor(UIColor.orange)
    }
    
    private func removeRecipe(_ recipe: Recipe) {
        changeNavigationItemColorFor(UIColor.white)
    }
}
