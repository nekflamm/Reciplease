//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 24/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    let recipeService = RecipeService()
    
    @IBOutlet weak var searchRecipesView: SearchRecipesView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchRecipesView.scheduledTimerWithTimeInterval()
    }
    
    @IBAction func searchRecipesButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toRecipesTableView", sender: self)
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        addIngredientsToList()
    }
    
//    private func getRecipe() {
//        recipeService.getRecipes { (success, recipe) in
//            guard let recipe = recipe, success else {
//                print("fail")
//                return
//            }
//            print(recipe.recipeName)
//        }
//    }
    
    private func addIngredientsToList() {
        guard let ingredient = searchRecipesView.ingredientsTextField.text  else {
            return
        }
        searchRecipesView.addIngredient(ingredient)
        IngredientsList.all.append(ingredient)
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        searchRecipesView.cleanTextView()
        IngredientsList.all.removeAll()
    }
}
