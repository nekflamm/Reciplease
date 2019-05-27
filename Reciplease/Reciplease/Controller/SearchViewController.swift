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
    
    @IBOutlet weak var globalView: UIView!
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var introductoryLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var ingredientsList = IngredientsList()
    private let animationManager = AnimationManager()
    private var secondBanner = UIImageView()
    
    // -----------------------------------------------------------------
    //              MARK: - @IBActions
    // -----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        launchAnimationLoop()
    }
    
    @IBAction func searchRecipesButton(_ sender: UIButton) {
        RecipesList.shared.recipes.removeAll()
        getRecipes()
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        addIngredientToList()
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        clearTextView()
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
                
                self.activityIndicator.isHidden = false
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
        activityIndicator.isHidden = true
        
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
        guard let ingredientName = ingredientsTextField.text?.lowercased(), ingredientName != "" else {
            return
        }
        ingredientsList.append(ingredientName)
        
        guard let newIngredient = ingredientsList.all.last else {
            return
        }
        
        if !introductoryLabel.isHidden {
            introductoryLabel.isHidden = true
        }
        
        ingredientsTextView.text += "• \(newIngredient.replacingOccurrences(of: "+", with: " "))\n\n"
        ingredientsTextField.text = nil
    }
    
    private func clearTextView() {
        ingredientsList.all.removeAll()
        
        introductoryLabel.isHidden = false
        ingredientsTextView.text = nil
    }
    
    @objc private func animate() {
        animationManager.bannerAnim(banner: banner, secondBanner: secondBanner)
    }
    
    func launchAnimationLoop() {
        let scndBanner = animationManager.setupBanner(banner: banner, scndBanner: secondBanner)
        
        globalView.insertSubview(scndBanner, belowSubview: banner)
        _ = Timer.scheduledTimer(timeInterval: (6.0), target: self, selector: #selector(animate), userInfo: nil, repeats: true)
    }
}

// -----------------------------------------------------------------
//              MARK: - Extensions
// -----------------------------------------------------------------
extension SearchViewController: UITextFieldDelegate {
    @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
        ingredientsTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ingredientsTextField.resignFirstResponder()
        
        addIngredientToList()
        
        return true
    }
}
