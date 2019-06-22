//
//  RecipeDetailsViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 24/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    // -----------------------------------------------------------------
    //              MARK: - @IBOutlets
    // -----------------------------------------------------------------
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var favoriteButtonOutlet: UIBarButtonItem!
    
    // -----------------------------------------------------------------
    //              MARK: - Properties
    // -----------------------------------------------------------------
    var recipe: Recipe?
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    
    private func setupView() {
        checkIfRecipeIsAlreadyFavorite()
        
        if let recipe = recipe {
            titleLabel.text = recipe.name
            ingredientsTextView.text = recipe.ingredientsToList
            imageView.image = recipe.image
            rateLabel.text = String(recipe.rating)
            timeLabel.text = "\(String(recipe.timeInSeconds / 60))m"
        }
    }
    
    // Set FavoriteButton to orange if recipe is already favorite
    private func checkIfRecipeIsAlreadyFavorite() {
        for savedRecipe in RecipeData.all {
            if recipe?.name == savedRecipe.name {
                favoriteButtonOutlet.tintColor = .orange
            }
        }
    }
    
    private func addRecipeToFavorites() {
        if let recipeIsFavorite = recipe?.isFavorite, !recipeIsFavorite {
            recipe?.isFavorite = true
            saveRecipe()
            
            favoriteButtonOutlet.tintColor = .orange
        }
    }
    
    private func saveRecipe() {
        if let recipe = recipe {
            let recipeData = RecipeData(context: AppDelegate.viewContext)
            
            recipeData.name = recipe.name
            recipeData.ingredients = recipe.ingredients
            recipeData.ingredientsList = recipe.followingIngredients
            recipeData.image = recipe.image.pngData()
            recipeData.rating = Int16(recipe.rating)
            recipeData.timeInSeconds = Int16(recipe.timeInSeconds)
            recipeData.id = recipe.id
            recipeData.isFavorite = recipe.isFavorite
            
            try? AppDelegate.viewContext.save()
        }
    }
    
    // Pass data to next ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is WebViewController {
            let viewController = segue.destination as? WebViewController
            
            viewController?.recipeID = recipe?.id
        }
    }
    
    // -----------------------------------------------------------------
    //              MARK: - @IBActions
    // -----------------------------------------------------------------
    @IBAction func addToFavoritesButton(_ sender: UIBarButtonItem) {
        addRecipeToFavorites()
    }
    
    @IBAction func getDirectionsButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToWebView", sender: self)
    }
}
