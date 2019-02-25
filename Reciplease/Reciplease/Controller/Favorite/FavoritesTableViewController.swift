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
        getFavorites(in: RecipesList.shared.recipes)
        getFavorites(in: RecipesList.shared.todaysRecipes)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecipesList.shared.favorites.count
//        return FavoritesList.all.count
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
        RecipesList.shared.selectedRecipes["favorite"] = RecipesList.shared.favorites[indexPath.row]
        RecipesList.shared.index = indexPath.row

        performSegue(withIdentifier: "toRecipeDetails2", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let index = removeFavorite(in: RecipesList.shared.recipes, for: indexPath) {
                    RecipesList.shared.recipes[index].isFavorite = false
        }
        if let scndIndex = removeFavorite(in: RecipesList.shared.todaysRecipes, for: indexPath) {
                    RecipesList.shared.todaysRecipes[scndIndex].isFavorite = false
        }
        RecipesList.shared.favorites.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .right)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }

    private func removeFavorite(in recipes: [Recipe], for indexPath: IndexPath) -> Int? {
        var index = 0

        for recipe in recipes {
            if recipe.name == RecipesList.shared.favorites[indexPath.row].name {

                return index
            }
            index += 1
        }
        return nil
    }
    
    private func getFavorites(in recipes: [Recipe]) {
        for recipe in recipes {
            if recipe.isFavorite && !IsAlreadyFavorite(recipe) {
                appendToFavorites(recipe)
            }
        }
    }
    
    private func appendToFavorites(_ recipe: Recipe) {
        RecipesList.shared.favorites.append(recipe)
    }
    
//    private func appendToFavorites(_ recipe: Recipe) {
//        let favoritesList = FavoritesList(context: AppDelegate.viewContext)
//        favoritesList.recipe = recipe
//        try? AppDelegate.viewContext.save()
//
//        for recipe in FavoritesList.all {
//            print(recipe.recipe?.name ?? "no recipe")
//        }
//    }
    
    
    
    private  func IsAlreadyFavorite(_ recipe: Recipe) -> Bool {
        for favorite in RecipesList.shared.favorites {
            if favorite.name ==  recipe.name {
                return true
            }
        }
        return false
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
