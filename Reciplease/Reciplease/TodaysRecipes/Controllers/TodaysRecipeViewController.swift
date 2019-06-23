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
    var recipesManager = RecipesManager()
    
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
        mealSelected = ["Breakfast", "Lunch", "TeaTime", "Dinner"][tag]
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
        
        RecipeService.shared.getRecipes(nil, mealSelected) { [weak self] (success, recipesData)   in
            guard let recipesData = recipesData, success else {
                self?.activityIndicator.isHidden = true
                self?.displayAlert(title: "No recipes found!", message: "Please retry.")
                return
            }
            
            self?.getImagesAndStoreRecipes(for: recipesData)
        }
    }
    
    private func getImagesAndStoreRecipes(for recipesData: [RecipeInfos]) {
        var images = [Int: UIImage]()
        
        for (i, recipeData) in recipesData.enumerated() {
            RecipeService.shared.getImage(for: getImageURL(for: recipeData)) { [weak self] (image) in
                guard let image = image else {
                    return
                }
                
                images[i] = image
                
                self?.storeRecipesIfNeeded(recipesInfos: recipesData, images: images)
            }
        }
    }
    
    private func storeRecipesIfNeeded(recipesInfos: [RecipeInfos], images: [Int: UIImage]) {
        if images.count == recipesInfos.count {
            recipesManager.fillRecipes(with: recipesManager.convertDataToRecipes(withData: recipesInfos, and: images))
            
            goToNextPage()
        }
    }
    
    func goToNextPage() {
        guard let recipesTableView = UIStoryboard(name: "RecipesTableView", bundle: nil).instantiateInitialViewController() as? RecipesTableViewController else {
            return
        }
        
        recipesTableView.recipes = recipesManager.getRecipes()
        recipesTableView.titleName = mealSelected
        push(recipesTableView)
        
        activityIndicator.isHidden = true
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
