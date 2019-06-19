//
//  FavoritesTableViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 24/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    var selectedRecipe: Recipe?
    
    // -----------------------------------------------------------------
    //              MARK: - Sections
    // -----------------------------------------------------------------
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecipeData.all.count
    }
    
    // -----------------------------------------------------------------
    //              MARK: - Cells
    // -----------------------------------------------------------------
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "mainCell")
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)  as? RecipeTableViewCell,
            let recipe = RecipeData.dataToRecipe(for: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.configure(with: recipe)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = RecipeData.dataToRecipe(for: indexPath.row)

        performSegue(withIdentifier: "toRecipeDetails2", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        removeFromContext(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .right)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------

    private func removeFromContext(at index: Int) {
        AppDelegate.viewContext.delete(RecipeData.all[index])
        try? AppDelegate.viewContext.save()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is RecipeDetailsViewController {
            let viewController = segue.destination as? RecipeDetailsViewController
            
            viewController?.recipe = selectedRecipe
        }
    }
}






//    private func removeFavorite(in recipes: [Recipe], at index: Int) -> Int? {
//        for (i, recipe) in recipes.enumerated() {
//            if recipe.name == RecipeData.all[i].name {
//
//                return i
//            }
//        }
//        return nil
//    }
//
//    private func removeFavorites(at index: Int) {
//        if let index = removeFavorite(in: RecipesList.shared.recipes, at: index) {
//            RecipesList.shared.recipes[index].isFavorite = false
//        }
//        if let scndIndex = removeFavorite(in: RecipesList.shared.todaysRecipes, at: index) {
//            RecipesList.shared.todaysRecipes[scndIndex].isFavorite = false
//        }
//    }
