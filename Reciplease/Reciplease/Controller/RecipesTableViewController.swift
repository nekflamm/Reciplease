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
}

extension RecipesTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecipesList.recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "mainCell")
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)  as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        let name = RecipesList.recipes[indexPath.row].name
        let ingredients = RecipesList.recipes[indexPath.row].ingredientsList
        let image = RecipesList.recipes[indexPath.row].image
        let rating = RecipesList.recipes[indexPath.row].ratingToString
        let time = RecipesList.recipes[indexPath.row].timeToString
        
        cell.configure(name: name, ingredients: ingredients, image: image, rating: rating, time: time)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RecipesList.selectedRecipe = RecipesList.recipes[indexPath.row]
        RecipesList.index = indexPath.row
//        let recipe = RecipesList.recipes[indexPath.row]
//        RecipesList.selectedRecipe = recipe
        
        performSegue(withIdentifier: "toRecipeDetails", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
}

