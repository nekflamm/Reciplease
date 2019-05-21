//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 24/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    // -----------------------------------------------------------------
    //             MARK: - Properties / @IBOutlets
    // -----------------------------------------------------------------
    @IBOutlet weak var searchRecipesView: SearchRecipesView!
    
    var ingredientsList = IngredientsList()
    
    // -----------------------------------------------------------------
    //              MARK: - @IBActions
    // -----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        searchRecipesView.scheduledTimerWithTimeInterval()
    }
    
    @IBAction func searchRecipesButton(_ sender: UIButton) {
        RecipesList.shared.recipes.removeAll()
        getRecipes()
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        addIngredientToList()
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        searchRecipesView.clearTextView()
        ingredientsList.all.removeAll()
    }
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    private func getRecipes() {
        let url = getURL()
        
        if !ingredientsList.all.isEmpty {
            RecipeService.shared.getRecipes(for: url) { (success, recipe, totalRecipes)   in
                guard let recipe = recipe?.last, let totalRecipes = totalRecipes, success else {
                    RecipeService.shared.resetFails()
                    self.clearTextView()
                    self.displayAlert(title: "No recipes found!", message: "Verify your ingredients.")
                    return
                }
                
                self.searchRecipesView.activityIndicatorState(hidden: false)
                RecipesList.shared.recipes.append(recipe)
                self.checkRecipesNumber(with: totalRecipes)
            }
        } else {
            displayAlert(title: "Ingredients missing!", message: "Please enter ingredients.")
        }
    }
    
    private func goToNextPage() {
        RecipeService.shared.resetFails()
        RecipesList.shared.emptyCentral()
        searchRecipesView.activityIndicatorState(hidden: true)
        
        performSegue(withIdentifier: "toRecipesTableView", sender: self)
    }
    
    private func checkRecipesNumber(with number: Int) {
        let fails = RecipeService.shared.fails
        
        if RecipesList.shared.recipes.count == number - fails {
            self.goToNextPage()
        } else if number == 0 {
            self.clearTextView()
            self.displayAlert(title: "No recipes found!", message: "Verify your ingredients.")
        }
    }
    
    private func getURL() -> URL {
        let parameter = ingredientsList.getAllowedIngredients()
        let url = URLManager.getSearchURL(with: parameter)
        
        return url
    }
    
    private func addIngredientToList() {
        guard let ingredient = searchRecipesView.ingredientsTextField.text, ingredient != "" else {
            return
        }
        let ingredientName = ingredient.lowercased()
        ingredientsList.append(ingredientName)
        
        guard let newIngredient = ingredientsList.all.last else {
            return
        }
        searchRecipesView.addIngredient(newIngredient)
    }
    
    private func clearTextView() {
        ingredientsList.all.removeAll()
        searchRecipesView.clearTextView()
    }
}

// -----------------------------------------------------------------
//              MARK: - Extensions
// -----------------------------------------------------------------
extension SearchViewController: UITextFieldDelegate {
    @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
        searchRecipesView.resignResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchRecipesView.resignResponder()
        addIngredientToList()
        
        return true
    }
}
