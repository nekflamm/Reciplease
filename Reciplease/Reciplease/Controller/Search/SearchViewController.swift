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
        ingredientsList.all.removeAll()
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
            RecipesList.shared.recipes.removeAll()
            
            RecipeService.shared.getRecipes(for: url) { (success, recipe, totalRecipes)   in
                guard let recipe = recipe?.last, let totalRecipes = totalRecipes, success else {
                    self.clearTextView()
                    self.presentNoRecipesAlert()
            
                    return
                }
                RecipesList.shared.recipes.append(recipe)
                self.checkRecipesNumber(with: totalRecipes)
            }
        } else {
            presentMissingIngredientsAlert()
        }
    }
    
    private func goToNextPage() {
        RecipesList.shared.emptyCentral()
        
        if RecipesList.shared.recipes.count != 0 {
            self.performSegue(withIdentifier: "toRecipesTableView", sender: self)
        } else {
            self.presentNoRecipesAlert()
        }
        self.clearTextView()
    }
    
    private func checkRecipesNumber(with number: Int?) {
        if RecipesList.shared.recipes.count == number {
            self.goToNextPage()
        } else if number == 0 || number == nil {
            self.presentNoRecipesAlert()
        }
    }
    
    private func getURL() -> URL {
        let ingredients = ingredientsList.getAllowedIngredients()
        let url = URLManager.getSearchURL(with: ingredients)
        
        return url
    }
    
    private func addIngredientToList() {
        guard let ingredient = searchRecipesView.ingredientsTextField.text, ingredient != "" else {
            return
        }
        ingredientsList.append(ingredient)
        
        guard let newIngredient = ingredientsList.all.last else {
            return
        }
        searchRecipesView.addIngredient(newIngredient)
    }
    
    private func clearTextView() {
        ingredientsList.all.removeAll()
        searchRecipesView.clearTextView()
    }
    
    private func presentMissingIngredientsAlert() {
        let errorAlert = UIAlertController(title: "Ingredients missing!", message: "Please enter ingredients.", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    private func presentNoRecipesAlert() {
        let errorAlert = UIAlertController(title: "No recipes found!", message: "Verify your ingredients.", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
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
