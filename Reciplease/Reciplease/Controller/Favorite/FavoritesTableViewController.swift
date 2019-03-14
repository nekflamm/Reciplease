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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecipeData.all.count
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
    
    private func configure(_ cell: RecipeTableViewCell, with indexPath: IndexPath) {
        guard let recipe = RecipeData.dataToRecipe(for: indexPath.row) else {
            return
        }
        cell.configure(name: recipe.name, ingredients: recipe.ingredientsList, image: recipe.image, rating: recipe.ratingToString, time: recipe.timeToString)
    }
    
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

//    private func appendToFavorites(_ recipe: Recipe) {
//        let favoritesList = FavoritesList(context: AppDelegate.viewContext)
//        favoritesList.recipe = recipe
//        try? AppDelegate.viewContext.save()
//
//        for recipe in FavoritesList.all {
//            print(recipe.recipe?.name ?? "no recipe")
//        }
//    }

//    private func getFavorites(in recipes: [Recipe]) {
//        for recipe in recipes {
//            if recipe.isFavorite && !IsAlreadyFavorite(recipe) {
//                appendToFavorites(recipe)
//            }
//        }
//    }

//    private func appendToFavorites(_ recipe: Recipe) {
//        RecipesList.shared.favorites.append(recipe)
//    }

//    private  func IsAlreadyFavorite(_ recipe: Recipe) -> Bool {
//        for favorite in RecipesList.shared.favorites {
//            if favorite.name ==  recipe.name {
//                return true
//            }
//        }
//        return false
//    }
