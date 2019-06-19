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
    //              MARK: - @IBOutlets / Properties
    // -----------------------------------------------------------------
    @IBOutlet var selectedImages: [UIImageView]!
    @IBOutlet var bannersView: [UIView]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let animationManager = AnimationManager()
    private var mealSelected = "Breakfast"
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        launchAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        launchAnimation()
    }
    
    private func launchAnimation() {
        animationManager.todaysPageAnim(for: bannersView, with: UIScreen.main.bounds.height)
    }
    
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
                    RecipesManager.shared.fillRecipes(forKey: "Meals", with: RecipesManager.shared.convertDataToRecipes(withData: recipesData, and: imagesArray))
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TodaysRecipeTableViewController {
            let viewController = segue.destination as? TodaysRecipeTableViewController
            
            viewController?.recipes = RecipesManager.shared.getRecipes(forKey: "Meals")
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






//    private func checkRecipesNumber(_ number: Int) {
//        if RecipesList.shared.todaysRecipes.count == number - RecipeService.shared.fails {
//            goToNextPage()
//        } else if number == 0 {
//            displayAlert(title: "Data not found !", message: "Please retry.")
//        }
//    }

//    private func getRecipes() {
//        RecipeService.shared.resetFails()
//        RecipesList.shared.todaysRecipes.removeAll()
//
//        RecipeService.shared.getRecipes(nil, mealSelected) { (success, recipe, totalRecipes)  in
//            guard let recipe = recipe?.last, let totalRecipes = totalRecipes, success else {
//                return
//            }
//            self.activityIndicator.isHidden = false
//
//            RecipesList.shared.todaysRecipes.append(recipe)
//            self.checkRecipesNumber(totalRecipes)
//        }
//    }
