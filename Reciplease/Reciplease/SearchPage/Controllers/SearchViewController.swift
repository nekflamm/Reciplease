//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 24/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController {
    // -----------------------------------------------------------------
    //             MARK: - @IBOutlets
    // -----------------------------------------------------------------
    @IBOutlet weak var globalView: UIView!
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var introductoryLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // -----------------------------------------------------------------
    //             MARK: - Properties
    // -----------------------------------------------------------------
    private let animationManager = AnimationManager()
    private var secondBanner = UIImageView()
    
    private var userIngredients = [String]()
    private var recipes = [Recipe]()
    
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
        guard let ingredient = ingredientsTextField.text?.formatted() else {
            return
        }
        
        ingredientsTextField.text?.removeAll()
        introductoryLabel.isHidden = true
        
        userIngredients.append(ingredient)
        
        ingredientsTableView.reloadData()
    }
    
    // Get recipe with inputed ingredients
    private func getRecipes() {
        guard !userIngredients.isEmpty else {
            return displayAlert(title: "Ingredients missing!", message: "Please enter ingredients.")
        }
        
        activityIndicator.isHidden = false
        
        RecipeService.shared.getRecipes(for: getAllowedIngredients()) { [weak self] (success, recipes)   in
            guard let recipes = recipes, !recipes.isEmpty, success else {
                self?.getRecipesHasFailed()
                return
            }
            
            self?.recipes = recipes
            
            self?.goToNextPage()
        }
    }
    
    private func getAllowedIngredients() -> String {
        return String(userIngredients.map { "\($0), " }.joined().dropLast(2))
    }
    
    private func getRecipesHasFailed() {
        activityIndicator.isHidden = true
        displayAlert(title: "No recipes found!", message: "Please retry.")
    }
    
    func goToNextPage() {
        guard let recipesTableView = UIStoryboard(name: "RecipesTableView", bundle: nil).instantiateInitialViewController() as? RecipesTableViewController else {
            return
        }
        
        recipesTableView.recipes = recipes
        recipesTableView.title = "Recipes"
        
        push(recipesTableView)
        
        clearPage()
    }
    
    private func clearPage() {
        introductoryLabel.isHidden = false
        activityIndicator.isHidden = true
        
        userIngredients.removeAll()
        ingredientsTableView.reloadData()
        
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
        clearPage()
    }
}

// -----------------------------------------------------------------
//              MARK: - Extensions
// -----------------------------------------------------------------
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "IngredientsCell", bundle: nil), forCellReuseIdentifier: "IngredientsCell")
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsCell", for: indexPath)  as? IngredientTableViewCell else {
                return UITableViewCell()
        }
        
        cell.configure(with: "• \(userIngredients[indexPath.row].replacingOccurrences(of: "+", with: " "))")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .right)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}

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
