//
//  TodaysRecipeViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 24/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit

class TodaysRecipeViewController: UIViewController, RequestsManagement {
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
    
    var requestsQueue = [Request]()
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
        
        RecipeService.shared.getRecipes(nil, mealSelected) { (success, recipesInfos)   in
            guard let recipesInfos = recipesInfos, success else {
                self.activityIndicator.isHidden = true
                self.displayAlert(title: "No recipes found!", message: "Please retry.")
                return
            }
            
            self.fillRequestsQueue(withNumber: recipesInfos.count)
            self.launchImagesRequests(withData: recipesInfos)
        }
    }
    
    // Pass data to next ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TodaysRecipeTableViewController {
            let viewController = segue.destination as? TodaysRecipeTableViewController
            
            viewController?.recipes = recipesManager.getRecipes()
        }
    }
    
    func goToNextPage() {
        self.performSegue(withIdentifier: "toRecipesTableView2", sender: self)
        
        activityIndicator.isHidden = true
        resetRequestsQueue()
        recipesManager.removeRecipes()
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
