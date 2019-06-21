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
        if segue.destination is TodaysRecipeTableViewController {
            let viewController = segue.destination as? TodaysRecipeTableViewController
            
            viewController?.recipes = recipesManager.getRecipes()
        }
    }
    
    private func goToNextPage() {
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
