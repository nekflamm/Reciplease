//
//  RecipeDetailsViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 24/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    
    private var recipe: Recipe?
    private var url: URL? {
        guard let recipe = recipe else {
            return nil
        }
        let id = recipe.id
        let url = URL(string: "http://api.yummly.com/v1/api/recipe/\(id)?_app_id=d2db4f54&_app_key=3d9d9071094ba629125874ebdfc836d8")
        
        return url
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
        addRecipeToFavorites()
    }
    
    @IBAction func getDirectionsButton(_ sender: UIButton) {
        guard let url = url else {
            return
        }

        RecipeService.shared.getUrl(for: url) { (success, url) in
            guard let url = url else {
                return
            }
            RecipesList.shared.selectedRecipes[RecipesList.shared.key]?.url = url
            self.performSegue(withIdentifier: "goToWebView", sender: self)
        }
    }
    
    private func getRecipe() -> Recipe {
        let key = RecipesList.shared.key
        
        guard let recipe = RecipesList.shared.selectedRecipes[key] else {
            return Recipe(name: String(), ingredients: [String()], image: UIImage(),
                          rating: Int(), timeInSeconds: Int(), id: String(), url: nil, isFavorite: false)
        }
        return recipe
    }
    
    private func setupView() {
        recipe = getRecipe()
        let ingredients = convertToList(recipe!.ingredients)
        recipeDetailsView.setup(title: recipe!.name, ingredients: ingredients, image: recipe!.image, rate: recipe!.ratingToString, time: recipe!.timeToString)
        checkIfRecipeIsFavorite()
    }
    
    private func checkIfRecipeIsFavorite() {
        let todaysRecipes = RecipesList.shared.todaysRecipes
        let searchRecipes = RecipesList.shared.recipes
        
        checkIfFavorite(for: "today", in: todaysRecipes)
        checkIfFavorite(for: "search", in: searchRecipes)
        
        if getKey() == "favorite" {
            changeNavigationItemColorFor(UIColor.orange)
        }
    }
    
    private func checkIfFavorite(for key: String, in recipes: [Recipe]) {
        let index = RecipesList.shared.index
        
        if getKey() == key {
            if recipes[index].isFavorite {
                changeNavigationItemColorFor(UIColor.orange)
            } else {
                changeNavigationItemColorFor(UIColor.white)
            }
        }
    }
    
    private func addRecipeToFavorites() {
        let index = RecipesList.shared.index
        
        switch getKey() {
        case "today":
            RecipesList.shared.todaysRecipes[index].isFavorite = true
        case "search":
            RecipesList.shared.recipes[index].isFavorite = true
        default:
            print("error")
        }
        changeNavigationItemColorFor(UIColor.orange)
    }
    
    private func getKey() -> String {
        return RecipesList.shared.key
    }
    
    private func changeNavigationItemColorFor(_ color: UIColor) {
        favoriteButtonOutlet.tintColor = color
    }
    
    private func convertToList(_ ingredients: [String]) -> String {
        var ingredientsList = ""
        
        for ingredient in ingredients {
            ingredientsList += "• \(ingredient)\n\n"
        }
        return ingredientsList
    }
}
