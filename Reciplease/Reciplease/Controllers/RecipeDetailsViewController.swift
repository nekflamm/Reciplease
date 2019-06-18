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
    //              MARK: - @IBOutlets / Properties
    // -----------------------------------------------------------------
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var favoriteButtonOutlet: UIBarButtonItem!
    
    private var recipe: Recipe {
        get {
            return getRecipe()
        } set {}
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
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is WebViewController {
            let viewController = segue.destination as? WebViewController

            viewController?.recipeID = recipe.id
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
        checkIfRecipeIsFavorite()
        
        let ingredients = convertToList(recipe.ingredients)
        
        titleLabel.text = recipe.name
        ingredientsTextView.text = ingredients
        imageView.image = recipe.image
        rateLabel.text = recipe.ratingToString
        timeLabel.text = recipe.timeToString
    }
    
    private func checkIfRecipeIsFavorite() {
        let todaysRecipes = RecipesList.shared.todaysRecipes
        let searchRecipes = RecipesList.shared.recipes

        checkIfFavorite(forKey: "today", in: todaysRecipes)
        checkIfFavorite(forKey: "search", in: searchRecipes)

        if getKey() == "favorite" {
            changeNavigationItemColorFor(.orange)
        }
    }

    private func checkIfFavorite(forKey key: String, in recipes: [Recipe]) {
        let index = RecipesList.shared.index

        if getKey() == key {
            if recipes[index].isFavorite {
                changeNavigationItemColorFor(.orange)
            } else {
                changeNavigationItemColorFor(.white)
            }
        }
    }
    
    private func addRecipeToFavorites() {
        let index = RecipesList.shared.index
        
        switch getKey() {
        case "today":
            RecipesList.shared.todaysRecipes[index].isFavorite = true
            saveRecipe()
        case "search":
            RecipesList.shared.recipes[index].isFavorite = true
            saveRecipe()
        default:
            print("error")
        }
        changeNavigationItemColorFor(.orange)
    }
    
    private func recipeIsAlreadyFavorite() -> Bool {
        for savedRecipe in RecipeData.all {
            if savedRecipe.name == recipe.name {
                
                return true
            }
        }
        return false
    }
    
    func getFollowingIngredientsNames(for ingredients: [String]) -> String {
        var string = String()
        for ingredient in ingredients {
            string += "\(ingredient), "
        }
        
        string.removeLast(2)
        return "\(string)."
    }
    
    private func convertToList(_ ingredients: [String]) -> String {
        var ingredientsList = ""
        
        for ingredient in ingredients {
            ingredientsList += "• \(ingredient)\n\n"
        }
        return ingredientsList
    }
    
    private func getKey() -> String {
        return RecipesList.shared.key
    }
    
    private func changeNavigationItemColorFor(_ color: UIColor) {
        favoriteButtonOutlet.tintColor = color
    }
    
    private func saveRecipe() {
        if !recipeIsAlreadyFavorite() {
            let image = recipe.image.pngData()
            let recipeData = RecipeData(context: AppDelegate.viewContext)
            
            recipeData.name = recipe.name
            recipeData.ingredients = recipe.ingredients
            recipeData.ingredientsList = getFollowingIngredientsNames(for: recipeData.ingredients!)
            recipeData.image = image
            recipeData.rating = Int16(recipe.rating)
            recipeData.ratingToString = String(recipeData.rating)
            recipeData.timeInSeconds = Int16(recipe.timeInSeconds)
            recipeData.timeToString = "\(String(recipeData.timeInSeconds / 60))m"
            recipeData.url = recipe.url
            recipeData.id = recipe.id
            recipeData.isFavorite = recipe.isFavorite
            
            try? AppDelegate.viewContext.save()
        }
    }
}
