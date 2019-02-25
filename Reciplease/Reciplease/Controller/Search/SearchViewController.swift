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
    //              MARK: - Methods / @IBActions
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
        addIngredientsToList()
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        searchRecipesView.clearTextView()
        ingredientsList.all.removeAll()
    }
    
    private func getRecipes() {
        guard let url = getURL() else {
            return
        }
        if !ingredientsList.all.isEmpty {
            RecipeService.shared.getRecipes(for: url) { (success, numberOfRecipes)   in
                if let recipesNumber = numberOfRecipes, success {
                    self.goToNextPage(recipesNumber: recipesNumber)
                }
            }
        } else {
            presentMissingIngredientsAlert()
        }
    }
    
    private func getURL() -> URL? {
        let allowedIngredients = ingredientsList.getAllowedIngredients()
        guard let url = URL(string: "https://api.yummly.com/v1/api/recipes?_app_id=d2db4f54&_app_key=3d9d9071094ba629125874ebdfc836d8&requirePictures=true\(allowedIngredients)&maxResult=30") else {
            return nil
        }
        return url
    }
    
    private func goToNextPage(recipesNumber: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
            RecipesList.shared.recipes = RecipesList.shared.central
            RecipesList.shared.emptyCentral()
            
            if RecipesList.shared.recipes.count != 0 {
                self.performSegue(withIdentifier: "toRecipesTableView", sender: self)
            } else {
                self.presentNoRecipesAlert()
            }
            self.clearTextView()
        }
    }
    
    private func addIngredientsToList() {
        guard let ingredient = searchRecipesView.ingredientsTextField.text  else {
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
        
        return true
    }
}
