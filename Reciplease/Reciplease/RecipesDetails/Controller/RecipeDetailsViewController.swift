//
//  RecipeDetailsViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 24/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit
import Kingfisher

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
        if isRecipeAlreadyFavorite() {
            favoriteButtonOutlet.tintColor = .orange
        }
        
        if let recipe = recipe,
            let time = recipe.totalTimeInSeconds {
            
            titleLabel.text = recipe.recipeName
            ingredientsTextView.text = recipe.ingredientsToList
            imageView.kf.setImage(with: getImageURL(for: recipe))
            rateLabel.text = String(recipe.rating)
            timeLabel.text = "\(String(time / 60))m"
        }
    }
    
    // Set FavoriteButton to orange if recipe is already favorite
    private func isRecipeAlreadyFavorite() -> Bool {
        for savedRecipe in RecipeData.all {
            if recipe?.recipeName == savedRecipe.name {
                
                return true
            }
        }
        return false
    }
    
    private func addRecipeToFavorites() {
        if isRecipeAlreadyFavorite() == false {
            saveRecipe()
            
            favoriteButtonOutlet.tintColor = .orange
        } else {
            displayAlert(title: "Fail.", message: "Recipe is already favorite.")
        }
    }
    
    private func saveRecipe() {
        if let recipe = recipe {
            let recipeData = RecipeData(context: AppDelegate.viewContext)
            
            recipeData.name = recipe.recipeName
            recipeData.ingredients = recipe.ingredients
            recipeData.imageURL = recipe.smallImageUrls
            recipeData.rating = Int16(recipe.rating)
            recipeData.timeInSeconds = Int16(recipe.totalTimeInSeconds ?? 0)
            recipeData.id = recipe.id
            
            try? AppDelegate.viewContext.save()
        }
    }
    
    // -----------------------------------------------------------------
    //              MARK: - @IBActions
    // -----------------------------------------------------------------
    @IBAction func addToFavoritesButton(_ sender: UIBarButtonItem) {
        addRecipeToFavorites()
    }
    
    @IBAction func getDirectionsButton(_ sender: UIButton) {
        guard let webViewController = UIStoryboard(name: "WebView", bundle: nil).instantiateInitialViewController() as? WebViewController else {
                return
        }
        
        webViewController.recipeID = recipe?.id
        
        push(webViewController)
    }
}
