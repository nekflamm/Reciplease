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
    //             MARK: - @IBOutlets
    // -----------------------------------------------------------------
    
    @IBOutlet weak var globalView: UIView!
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var introductoryLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // -----------------------------------------------------------------
    //             MARK: - Properties
    // -----------------------------------------------------------------
    private var ingredientsList = IngredientsList()
    private var recipesManager = RecipesManager()
    private let animationManager = AnimationManager()
    private var secondBanner = UIImageView()
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        launchAnimationLoop()
    }
    
    // Setup and launch banner's animation
    private func launchAnimationLoop() {
        let scndBanner = animationManager.setupBanner(banner: banner, scndBanner: secondBanner)
        
        globalView.insertSubview(scndBanner, belowSubview: banner)
        _ = Timer.scheduledTimer(timeInterval: (6.0), target: self, selector: #selector(animate), userInfo: nil, repeats: true)
    }
    
    @objc private func animate() {
        animationManager.bannerAnim(banner: banner, secondBanner: secondBanner)
    }
    
    private func addIngredientToList() {
        guard let ingredientName = ingredientsTextField.text?.lowercased(), ingredientName != "" else {
            return
        }
        
        ingredientsList.append(ingredientName)
        
        guard let newIngredient = ingredientsList.all.last else {
            return
        }
        
        ingredientsTextView.text += "• \(newIngredient.replacingOccurrences(of: "+", with: " "))\n\n"
        ingredientsTextField.text = nil
        introductoryLabel.isHidden = true
    }
    
    // Get recipe with inputed ingredients
    private func getRecipes() {
        if !ingredientsList.all.isEmpty {
            activityIndicator.isHidden = false
            
            RecipeService.shared.getRecipes(ingredientsList.getAllowedIngredients(), nil) { (success, recipesInfos)   in
                guard let recipesInfos = recipesInfos, !recipesInfos.isEmpty, success else {
                    self.activityIndicator.isHidden = true
                    self.clearTextView()
                    self.displayAlert(title: "No recipes found!", message: "Verify your ingredients.")
                    return
                }
                
                self.getImagesAndStoreRecipes(for: recipesInfos)
            }
        } else {
            displayAlert(title: "Ingredients missing!", message: "Please enter ingredients.")
        }
    }
    
    // Get recipes images and store recipes
    private func getImagesAndStoreRecipes(for recipesData: [RecipeInfos]) {
        var imagesArray = [UIImage]()
        
        for recipeData in recipesData {
            let imageURL = getImageURL(for: recipeData)
            
            RecipeService.shared.getImage(for: imageURL) { (image) in
                guard let image = image else {
                    return
                }
                
                imagesArray.append(image)
                
                self.fillRecipesIfNeeded(check: imagesArray, and: recipesData)
            }
        }
    }
    
    // Check if images and recipes number is the same and fill recipes if needed
    private func fillRecipesIfNeeded(check imagesArray: [UIImage], and recipesData: [RecipeInfos]) {
        if imagesArray.count == recipesData.count {
            recipesManager.fillRecipes(forKey: "Search", with: recipesManager.convertDataToRecipes(withData: recipesData, and: imagesArray))
            goToNextPage()
        }
    }
    
    // Pass data to next ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is RecipesTableViewController {
            let viewController = segue.destination as? RecipesTableViewController
            
            viewController?.recipes = recipesManager.getRecipes(forKey: "Search")
        }
    }
    
    private func goToNextPage() {
        clearTextView()
        activityIndicator.isHidden = true
        
        performSegue(withIdentifier: "toRecipesTableView", sender: self)
    }
    
    private func clearTextView() {
        ingredientsList.all.removeAll()
        
        introductoryLabel.isHidden = false
        ingredientsTextView.text = nil
    }
    
    // -----------------------------------------------------------------
    //              MARK: - @IBActions
    // -----------------------------------------------------------------
    @IBAction func searchRecipesButton(_ sender: UIButton) {
        getRecipes()
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        addIngredientToList()
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        clearTextView()
        ingredientsList.all.removeAll()
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
