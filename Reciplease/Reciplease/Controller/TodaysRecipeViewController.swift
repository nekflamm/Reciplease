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
    @IBOutlet var selectedImages: [UIImageView]!
    @IBOutlet var bannersView: [UIView]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var todaysRecipe = TodaysRecipe()
    private let animationManager = AnimationManager()
    
    // -----------------------------------------------------------------
    //              MARK: - @IBActions
    // -----------------------------------------------------------------
    @IBAction func searchRecipesButton(_ sender: UIButton) {
        getRecipes()
    }
    
    @IBAction func mealsButtons(_ sender: UIButton) {
        todaysRecipe.setMeal(for: sender.tag)
        setSelectedImage(for: sender.tag)
    }
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        launchAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        launchAnimation()
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
            self.activityIndicator.isHidden = false
            
            RecipesList.shared.todaysRecipes.append(recipe)
            self.checkRecipesNumber(totalRecipes)
        }
    }
    
    private func goToNextPage() {
        RecipeService.shared.resetFails()
        RecipesList.shared.emptyCentral()
        
        activityIndicator.isHidden = true
        
        self.performSegue(withIdentifier: "toRecipesTableView2", sender: self)
    }
    
    private func checkRecipesNumber(_ number: Int) {
        let fails = RecipeService.shared.fails
        
        if RecipesList.shared.todaysRecipes.count == number - fails {
            goToNextPage()
        } else if number == 0 {
            displayAlert(title: "Data not found !", message: "Please retry.")
        }
    }
    
    func setSelectedImage(for index: Int) {
        for image in selectedImages {
            image.image = UIImage(named: "notSelected")
        }
        selectedImages[index].image = UIImage(named: "selected")
    }
    
    func launchAnimation() {
        let translation = UIScreen.main.bounds.height
        animationManager.todaysPageAnim(for: bannersView, with: translation)
    }
}
