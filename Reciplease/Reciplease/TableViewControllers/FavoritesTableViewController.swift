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
        RecipesList.shared.selectedRecipes["favorite"] = RecipeData.dataToRecipe(for: indexPath.row)
        RecipesList.shared.index = indexPath.row

        performSegue(withIdentifier: "toRecipeDetails2", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        removeFavorites(for: indexPath)
        removeFromContext(for: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .right)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    private func removeFavorite(in recipes: [Recipe], for indexPath: IndexPath) -> Int? {
        var index = 0
        
        for recipe in recipes {
            if recipe.name == RecipeData.all[indexPath.row].name {

                return index
            }
            index += 1
        }
        return nil
    }
    
    private func removeFavorites(for indexPath: IndexPath) {
        if let index = removeFavorite(in: RecipesList.shared.recipes, for: indexPath) {
            RecipesList.shared.recipes[index].isFavorite = false
        }
        if let scndIndex = removeFavorite(in: RecipesList.shared.todaysRecipes, for: indexPath) {
            RecipesList.shared.todaysRecipes[scndIndex].isFavorite = false
        }
    }
    
    private func removeFromContext(for index: Int) {
        AppDelegate.viewContext.delete(RecipeData.all[index])
        try? AppDelegate.viewContext.save()
    }
}
