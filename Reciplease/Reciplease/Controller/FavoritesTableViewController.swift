//
//  FavoritesTableViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 24/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
        tableView.reloadData()
    }

    private func getFavorites() {
        Favorite.recipes.removeAll()
        for recipe in RecipesList.recipes {
            if recipe.isFavorite {
                Favorite.recipes.append(recipe)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Favorite.recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "mainCell")
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)  as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        let name = Favorite.recipes[indexPath.row].name
        let ingredients = Favorite.recipes[indexPath.row].ingredientsList
        let image = Favorite.recipes[indexPath.row].image
        let rating = Favorite.recipes[indexPath.row].ratingToString
        let time = Favorite.recipes[indexPath.row].timeToString
        
        cell.configure(name: name, ingredients: ingredients, image: image, rating: rating, time: time)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RecipesList.selectedRecipe = Favorite.recipes[indexPath.row]
        RecipesList.index = indexPath.row
//        let recipe = Favorite.recipes[indexPath.row]
//        RecipesList.selectedRecipe = recipe

        performSegue(withIdentifier: "toRecipeDetails2", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Favorite.recipes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
}
