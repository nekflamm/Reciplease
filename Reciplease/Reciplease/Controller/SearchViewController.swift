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
    
    // -----------------------------------------------------------------
    //              MARK: - Methods / @IBActions
    // -----------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchRecipesView.scheduledTimerWithTimeInterval()
    }
    
    @IBAction func searchRecipesButton(_ sender: UIButton) {
        RecipesList.recipes.removeAll()
        getRecipes()
        IngredientsList.all.removeAll()
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        addIngredientsToList()
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        searchRecipesView.clearTextView()
        IngredientsList.all.removeAll()
    }
    
    private func getRecipes() {
        if !IngredientsList.all.isEmpty {
            RecipeService.shared.getRecipes { (success) in
                if success {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.searchRecipesView.clearTextView()
                        self.performSegue(withIdentifier: "toRecipesTableView", sender: self)
                    }
                } else {
                    self.presentNoRecipesAlert()
                }
            }
        } else {
            presentMissingIngredientsAlert()
        }
    }
    
    private func addIngredientsToList() {
        guard let ingredient = searchRecipesView.ingredientsTextField.text  else {
            return
        }
        searchRecipesView.addIngredient(ingredient)
        IngredientsList.all.append(ingredient)
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
