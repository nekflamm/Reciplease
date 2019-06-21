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
    
    var requestsQueue = [Request]()
    
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
                
                self.fillRequestsQueue(withNumber: recipesInfos.count)
                self.launchImagesRequests(withData: recipesInfos)
            }
        } else {
            displayAlert(title: "Ingredients missing!", message: "Please enter ingredients.")
        }
    }
    
    private func launchImagesRequests(withData recipesInfos: [RecipeInfos]) {
        if !isAllRequestsDone() {
            for (index, request) in requestsQueue.enumerated() {
                if request.state == .waiting && (requestsQueue.filter{ $0.state == .inProgress }).count == 0 {
                    getImageAndStoreRecipe(for: recipesInfos, at: index)
                }
            }
        } else {
            goToNextPage()
        }
    }
    
    // Get recipes images and store recipes
    private func getImageAndStoreRecipe(for recipesData: [RecipeInfos], at index: Int) {
        requestsQueue[index].state = .inProgress
        
        RecipeService.shared.getImage(for: getImageURL(for: recipesData[index])) { (image) in
            guard let image = image else {
                self.requestsQueue[index].state = .failed
                return
            }
            
            self.recipesManager.fillRecipe(with: self.recipesManager.convertDataToRecipe(withData: recipesData[index], and: image))
            self.requestsQueue[index].state = .done
            
            self.launchImagesRequests(withData: recipesData)
        }
    }
    
    private func isAllRequestsDone() -> Bool {
        return (requestsQueue.filter { $0.state == .done}).count == (requestsQueue.filter {$0.state != .failed}).count
    }
    
    // Pass data to next ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is RecipesTableViewController {
            let viewController = segue.destination as? RecipesTableViewController
            
            viewController?.recipes = recipesManager.getRecipes()
        }
    }
    
    private func goToNextPage() {
        performSegue(withIdentifier: "toRecipesTableView", sender: self)
        
        clearTextView()
        activityIndicator.isHidden = true
        resetRequestsQueue()
        recipesManager.removeRecipes()
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
