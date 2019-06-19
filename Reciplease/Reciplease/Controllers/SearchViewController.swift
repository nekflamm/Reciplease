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
    private let animationManager = AnimationManager()
    private var secondBanner = UIImageView()
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        launchAnimationLoop()
    }
    
    private func launchAnimationLoop() {
        let scndBanner = animationManager.setupBanner(banner: banner, scndBanner: secondBanner)
        
        globalView.insertSubview(scndBanner, belowSubview: banner)
        _ = Timer.scheduledTimer(timeInterval: (6.0), target: self, selector: #selector(animate), userInfo: nil, repeats: true)
    }
    
    private func getRecipes() {
        if !ingredientsList.all.isEmpty {
            self.activityIndicator.isHidden = false
            
            RecipeService.shared.getRecipes(ingredientsList.getAllowedIngredients(), nil) { (success, recipesInfos)   in
                guard let recipesInfos = recipesInfos, success else {
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
    
    private func getImagesAndStoreRecipes(for recipesData: [RecipeInfos]) {
        var imagesArray = [UIImage]()
        var imageURL = URL(string: Constants.URL.defaultImageURL)!
        
        for recipeData in recipesData {
            if let firstImageURL = recipeData.smallImageUrls?.first {
                imageURL = modifyImageSizeUrl(firstImageURL)
            }
            
            RecipeService.shared.getImage(for: imageURL) { (image) in
                guard let image = image else {
                    return
                }
                
                imagesArray.append(image)
                
                if imagesArray.count == recipesData.count {
                    RecipesManager.shared.fillRecipes(forKey: "Search", with: RecipesManager.shared.convertDataToRecipes(withData: recipesData, and: imagesArray))
                    self.goToNextPage()
                }
            }
        }
    }
    
    private func modifyImageSizeUrl(_ imageUrl: String) -> URL {
        var stringUrl = imageUrl
        stringUrl.removeLast(2)
        stringUrl.append(String(Int(Double(self.view.frame.width))))
        
        guard let url = URL(string: stringUrl) else {
            return URL(string: "Error")!
        }
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is RecipesTableViewController {
            let viewController = segue.destination as? RecipesTableViewController
            
            viewController?.recipes = RecipesManager.shared.getRecipes(forKey: "Search")
        }
    }
    
    private func goToNextPage() {
        clearTextView()
        activityIndicator.isHidden = true
        
        performSegue(withIdentifier: "toRecipesTableView", sender: self)
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





//    private func getRecipes() {
//        if !ingredientsList.all.isEmpty {
//            RecipeService.shared.getRecipes(ingredientsList.getAllowedIngredients(), nil) { (success, recipe, totalRecipes)   in
//                guard let recipe = recipe?.last, let totalRecipes = totalRecipes, success else {
//                    RecipeService.shared.resetFails()
//                    self.clearTextView()
//                    self.displayAlert(title: "No recipes found!", message: "Verify your ingredients.")
//                    return
//                }
//
//                self.activityIndicator.isHidden = false
//
//                RecipesList.shared.recipes.append(recipe)
//                self.checkRecipesNumber(with: totalRecipes)
//            }
//        } else {
//            displayAlert(title: "Ingredients missing!", message: "Please enter ingredients.")
//        }
//    }

//    private func checkRecipesNumber(with number: Int) {
//        if RecipesList.shared.recipes.count == number - RecipeService.shared.fails {
//            self.goToNextPage()
//        } else if number == 0 {
//            self.clearTextView()
//            self.displayAlert(title: "No recipes found!", message: "Verify your ingredients.")
//        }
//    }
