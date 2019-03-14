//
//  TodaysRecipeViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 24/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit

class TodaysRecipeViewController: UIViewController {
    var todaysRecipe = TodaysRecipe()
    
    @IBOutlet weak var mealsView: MealsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        mealsView.scheduledTimerWithTimeInterval()
    }
    
    @IBAction func searchRecipesButton(_ sender: UIButton) {
        getRecipes()
    }
    
    @IBAction func mealsButtons(_ sender: UIButton) {
        todaysRecipe.setMeal(for: sender.tag)
        mealsView.selectImage(for: sender.tag)
    }
    
    private func getRecipes() {
        let meal = todaysRecipe.mealSelected
        let url = URLManager.getTodaysURL(with: meal)
        
        RecipesList.shared.todaysRecipes.removeAll()
        RecipeService.shared.getRecipes(for: url) { (success, recipe, totalRecipes)  in
            guard let recipe = recipe?.last, let totalRecipes = totalRecipes, success else {
                return
            }
            RecipesList.shared.todaysRecipes.append(recipe)
            if RecipesList.shared.todaysRecipes.count == totalRecipes {
                self.goToNextPage()
            }
        }
    }
    
    private func goToNextPage() {
        RecipesList.shared.emptyCentral()
        self.performSegue(withIdentifier: "toRecipesTableView2", sender: self)
    }
    
    private func presentDataNotFoundAlert() {
        let errorAlert = UIAlertController(title: "Data not found", message: "Please retry.", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
    }
}
