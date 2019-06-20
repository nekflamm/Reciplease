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
    //              MARK: - @IBOutlets
    // -----------------------------------------------------------------
    @IBOutlet var selectedImages: [UIImageView]!
    @IBOutlet var bannersView: [UIView]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // -----------------------------------------------------------------
    //              MARK: - Properties
    // -----------------------------------------------------------------
    private let animationManager = AnimationManager()
    private let recipesManager = RecipesManager()
    
    private var mealSelected = "Breakfast"
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        launchAnimation()
    }
    
    private func launchAnimation() {
        animationManager.todaysPageAnim(for: bannersView, with: UIScreen.main.bounds.height)
    }
    
    // Change the mealSelected with user choice
    private func setMealSelected(for tag: Int) {
        let possiblesMeals = ["Breakfast", "Lunch", "TeaTime", "Dinner"]
        
        mealSelected = possiblesMeals[tag]
    }
    
    private func setSelectedImage(for index: Int) {
        for image in selectedImages {
            image.image = UIImage(named: "notSelected")
        }
        
        selectedImages[index].image = UIImage(named: "selected")
    }
    
    // Get recipe with inputed ingredients
    private func getRecipes() {
        self.activityIndicator.isHidden = false
        
        RecipeService.shared.getRecipes(nil, mealSelected) { (success, recipesInfos)   in
            guard let recipesInfos = recipesInfos, success else {
                self.displayAlert(title: "No recipes found!", message: "Please retry.")
                return
            }
            
            self.getImagesAndStoreRecipes(for: recipesInfos)
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
            recipesManager.fillRecipes(forKey: "Meals", with: recipesManager.convertDataToRecipes(withData: recipesData, and: imagesArray))
            goToNextPage()
        }
    }
    
    // Pass data to next ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TodaysRecipeTableViewController {
            let viewController = segue.destination as? TodaysRecipeTableViewController
            
            viewController?.recipes = recipesManager.getRecipes(forKey: "Meals")
        }
    }
    
    private func goToNextPage() {
        activityIndicator.isHidden = true
        
        self.performSegue(withIdentifier: "toRecipesTableView2", sender: self)
    }
    
    // -----------------------------------------------------------------
    //              MARK: - @IBActions
    // -----------------------------------------------------------------
    @IBAction func searchRecipesButton(_ sender: UIButton) {
        getRecipes()
    }
    
    @IBAction func mealsButtons(_ sender: UIButton) {
        setMealSelected(for: sender.tag)
        setSelectedImage(for: sender.tag)
    }
}
