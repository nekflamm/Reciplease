//
//  RecipeDetailsViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 24/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    
    var recipe: Recipe {
        get {
            return getRecipe()
        } 
    }
    
    @IBOutlet weak var recipeDetailsView: RecipeDetailsView!
    @IBOutlet weak var favoriteButtonOutlet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    
    @IBAction func addToFavoritesButton(_ sender: UIBarButtonItem) {
        setOrRemoveFavorite()
    }
    
    private func getRecipe() -> Recipe {
        guard let recipe = RecipesList.shared.selectedRecipe else {
            return Recipe(name: "", ingredients: [""], image: UIImage(),
                          rating: 0, timeInSeconds: 0, isFavorite: false)
        }
        return recipe
    }
    
    private func setupView() {
        let ingredients = convertToList(recipe.ingredients)
        recipeDetailsView.setup(title: recipe.name, ingredients: ingredients, image: recipe.image, rate: recipe.ratingToString, time: recipe.timeToString)
        checkIfFavorite()
    }
    
    private func checkIfFavorite() {
        if recipe.isFavorite {
            addRecipeToFavorites()
        } else {
            removeRecipeFromFavorites()
        }
    }
    
    private func setOrRemoveFavorite() {
        if RecipesList.shared.recipes[RecipesList.shared.index].isFavorite {
            RecipesList.shared.recipes[RecipesList.shared.index].isFavorite = false
            removeRecipeFromFavorites()
        } else {
            RecipesList.shared.recipes[RecipesList.shared.index].isFavorite = true
            addRecipeToFavorites()
        }
    }
    
    private func convertToList(_ ingredients: [String]) -> String {
        var ingredientsList = ""
        
        for ingredient in ingredients {
            ingredientsList += "• \(ingredient)\n\n"
        }
        return ingredientsList
    }
    
    private func addRecipeToFavorites() {
        changeNavigationItemColorFor(UIColor.orange)
    }
    
    private func removeRecipeFromFavorites() {
        changeNavigationItemColorFor(UIColor.white)
    }
    
    private func changeNavigationItemColorFor(_ color: UIColor) {
        favoriteButtonOutlet.tintColor = color
    }
}
