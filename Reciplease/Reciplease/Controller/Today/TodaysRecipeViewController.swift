//
//  TodaysRecipeViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 24/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit

class TodaysRecipeViewController: UIViewController {
    // -----------------------------------------------------------------
    //              MARK: - @IBOutlets / Properties
    // -----------------------------------------------------------------
    var todaysRecipe = TodaysRecipe()
    
    @IBOutlet weak var mealsView: MealsView!
    
    // -----------------------------------------------------------------
    //              MARK: - @IBActions
    // -----------------------------------------------------------------
    @IBAction func searchRecipesButton(_ sender: UIButton) {
        getRecipes()
    }
    
    @IBAction func mealsButtons(_ sender: UIButton) {
        todaysRecipe.setMeal(for: sender.tag)
        mealsView.selectImage(for: sender.tag)
    }
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealsView.animate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mealsView.animate()
    }
    
    private func getRecipes() {
        let meal = todaysRecipe.mealSelected
        let url = URLManager.getTodaysURL(with: meal)
        
        RecipeService.shared.resetFails()
        
        RecipesList.shared.todaysRecipes.removeAll()
        RecipeService.shared.getRecipes(for: url) { (success, recipe, totalRecipes)  in
            guard let recipe = recipe?.last, let totalRecipes = totalRecipes, success else {
                return
            }
            self.mealsView.activityIndicatorState(hidden: false)
            RecipesList.shared.todaysRecipes.append(recipe)
            self.checkRecipesNumber(totalRecipes)
//            if RecipesList.shared.todaysRecipes.count == totalRecipes {
//                self.goToNextPage()
//            }
        }
    }
    
    private func goToNextPage() {
        RecipeService.shared.resetFails()
        RecipesList.shared.emptyCentral()
        mealsView.activityIndicatorState(hidden: true)
        
        self.performSegue(withIdentifier: "toRecipesTableView2", sender: self)
    }
    
    private func checkRecipesNumber(_ number: Int) {
        let fails = RecipeService.shared.fails
        
        if RecipesList.shared.todaysRecipes.count == number - fails {
            goToNextPage()
        } else if number == 0 {
            presentDataNotFoundAlert()
        }
    }
    
    // -----------------------------------------------------------------
    //              MARK: - Alerts
    // -----------------------------------------------------------------
    private func presentDataNotFoundAlert() {
        let errorAlert = UIAlertController(title: "Data not found", message: "Please retry.", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
    }
}
