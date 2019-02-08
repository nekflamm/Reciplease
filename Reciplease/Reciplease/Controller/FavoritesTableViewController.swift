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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecipesList.shared.favorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "mainCell")
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)  as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        configure(cell, with: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RecipesList.shared.selectedRecipe = RecipesList.shared.favorites[indexPath.row]
        RecipesList.shared.index = indexPath.row

        performSegue(withIdentifier: "toRecipeDetails2", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let index = removeFavorite(for: indexPath) else {
                return
            }
            RecipesList.shared.recipes[index].isFavorite = false
            
            tableView.deleteRows(at: [indexPath], with: .right)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    private func removeFavorite(for indexPath: IndexPath) -> Int? {
        RecipesList.shared.index = 0
        for recipe in RecipesList.shared.recipes {
            if recipe.name == RecipesList.shared.favorites[indexPath.row].name {
                RecipesList.shared.favorites.remove(at: indexPath.row)
                
                return RecipesList.shared.index
            }
            RecipesList.shared.index += 1
        }
        return nil
    }
    
    private func getFavorites() {
        RecipesList.shared.favorites.removeAll()
        for recipe in RecipesList.shared.recipes {
            if recipe.isFavorite {
                RecipesList.shared.favorites.append(recipe)
            }
        }
    }
    
    private func configure(_ cell: RecipeTableViewCell, with indexPath: IndexPath) {
        let name = RecipesList.shared.favorites[indexPath.row].name
        let ingredients = RecipesList.shared.favorites[indexPath.row].ingredientsList
        let image = RecipesList.shared.favorites[indexPath.row].image
        let rating = RecipesList.shared.favorites[indexPath.row].ratingToString
        let time = RecipesList.shared.favorites[indexPath.row].timeToString
        
        cell.configure(name: name, ingredients: ingredients, image: image, rating: rating, time: time)
    }
}
