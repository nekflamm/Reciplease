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
    
    @IBAction func searchRecipesButton(_ sender: UIButton) {
        getRecipes()
    }
    
    @IBAction func mealsButtons(_ sender: UIButton) {
        todaysRecipe.setMeal(for: sender.tag)
        mealsView.selectImage(for: sender.tag)
    }
    
    private func getRecipes() {
        guard let url = todaysRecipe.getURL() else {
            return
        }
        RecipeService.shared.getRecipes(for: url) { (success) in
            if success {
                self.goToNextPage()
            } else {
                self.presentDataNotFoundAlert()
            }
        }
    }
    
    private func goToNextPage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            RecipesList.shared.todaysRecipes = RecipesList.shared.central
            RecipesList.shared.emptyCentral()
            self.performSegue(withIdentifier: "toRecipesTableView2", sender: self)
        }
    }
    
    private func presentDataNotFoundAlert() {
        let errorAlert = UIAlertController(title: "Data not found", message: "Please retry.", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
    }
}
