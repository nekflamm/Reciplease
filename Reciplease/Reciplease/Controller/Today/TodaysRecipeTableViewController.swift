//
//  TodaysRecipeTableViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 08/02/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit

class TodaysRecipeTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecipesList.shared.todaysRecipes.count
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
        RecipesList.shared.selectedRecipes["today"] = RecipesList.shared.todaysRecipes[indexPath.row]
        
        RecipesList.shared.index = indexPath.row

        performSegue(withIdentifier: "toRecipeDetails3", sender: self)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    private func configure(_ cell: RecipeTableViewCell, with indexPath: IndexPath) {
        let name = RecipesList.shared.todaysRecipes[indexPath.row].name
        let ingredients = RecipesList.shared.todaysRecipes[indexPath.row].ingredientsList
        let image = RecipesList.shared.todaysRecipes[indexPath.row].image
        let rating = RecipesList.shared.todaysRecipes[indexPath.row].ratingToString
        let time = RecipesList.shared.todaysRecipes[indexPath.row].timeToString
        
        cell.configure(name: name, ingredients: ingredients, image: image, rating: rating, time: time)
    }
}
