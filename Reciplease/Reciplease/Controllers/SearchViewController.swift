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
    var recipesManager = RecipesManager()
    private var ingredientsList = IngredientsList()
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
                    self.displayAlert(title: "No recipes found!", message: "Please retry.")
                    return
                }
                
                self.getImagesAndStoreRecipes(for: recipesInfos)
            }
        } else {
            displayAlert(title: "Ingredients missing!", message: "Please enter ingredients.")
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    private func getImagesAndStoreRecipes(for recipesData: [RecipeInfos]) {
        var images = [Int: UIImage]()
        
        for (i, recipeData) in recipesData.enumerated() {
            RecipeService.shared.getImage(for: getImageURL(for: recipeData)) { (image) in
                guard let image = image else {
                    return
                }
                
                images[i] = image
                
                self.storeRecipesIfNeeded(recipesInfos: recipesData, images: images)
            }
        }
    }
    
    private func storeRecipesIfNeeded(recipesInfos: [RecipeInfos], images: [Int: UIImage]) {
        if images.count == recipesInfos.count {
            recipesManager.fillRecipes(with: recipesManager.convertDataToRecipes(withData: recipesInfos, and: images))
            
            goToNextPage()
        }
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Pass data to next ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is RecipesTableViewController {
            let viewController = segue.destination as? RecipesTableViewController
            
            viewController?.recipes = recipesManager.getRecipes()
        }
    }
    
    func goToNextPage() {
        performSegue(withIdentifier: "toRecipesTableView", sender: self)
        
        clearTextView()
        activityIndicator.isHidden = true
//        resetRequestsQueue()
//        recipesManager.removeRecipes()
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
