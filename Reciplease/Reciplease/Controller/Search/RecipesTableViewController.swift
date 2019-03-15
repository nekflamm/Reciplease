//
//  RecipesTableViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 24/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit

class RecipesTableViewController: UITableViewController {
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
        return RecipesList.shared.recipes.count
    }
    
    // -----------------------------------------------------------------
    //              MARK: - Cells
    // -----------------------------------------------------------------
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "mainCell")
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)  as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        configure(cell, with: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RecipesList.shared.selectedRecipes["search"] = RecipesList.shared.recipes[indexPath.row]
        RecipesList.shared.index = indexPath.row
        
        performSegue(withIdentifier: "toRecipeDetails", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    private func configure(_ cell: RecipeTableViewCell, with indexPath: IndexPath) {
        let recipe = RecipesList.shared.recipes[indexPath.row]
        
        cell.configure(name: recipe.name, ingredients: recipe.ingredientsList, image: recipe.image, rating: recipe.ratingToString, time: recipe.timeToString)
    }
}

