//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 24/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchRecipesView: SearchRecipesView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRecipe()
        searchRecipesView.scheduledTimerWithTimeInterval()
    }
    
    @IBAction func searchRecipesButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toRecipesTableView", sender: self)
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        addIngredientsToList()
    }
    
    private func getRecipe() {
        RecipeService.shared.getRecipes { (success, recipe) in
            guard let recipe = recipe, success else {
                return
            }
            self.searchRecipesView.banner.image = UIImage(data: recipe.image)
        }
    }
    
    private func addIngredientsToList() {
        guard let ingredient = searchRecipesView.ingredientsTextField.text  else {
            return
        }
        searchRecipesView.addIngredient(ingredient)
        IngredientsList.all.append(ingredient)
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        searchRecipesView.clearTextView()
        IngredientsList.all.removeAll()
        getRecipe()
    }
}

extension SearchViewController: UITextFieldDelegate {
    @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
        searchRecipesView.resignResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchRecipesView.resignResponder()
        
        return true
    }
}
