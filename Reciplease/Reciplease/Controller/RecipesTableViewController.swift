//
//  RecipesTableViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 24/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit

class RecipesTableViewController: UITableViewController {

    var recipesList = RecipesList()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension RecipesTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesList.recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)  as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(recipeName: recipesList.recipes[indexPath.row].recipeName, ingredients: recipesList.recipes[indexPath.row].ingredientsList, image: recipesList.recipes[indexPath.row].image)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = recipesList.recipes[indexPath.row]
        RecipesList.selectedRecipe = recipe
        
        performSegue(withIdentifier: "toRecipeDetails", sender: self)
    }
}

