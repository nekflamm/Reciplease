//
//  RecipesTableViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 24/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit

class RecipesTableViewController: UITableViewController {

    let recipeList = RecipesList()
    
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
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)  as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(recipeName: recipeList.recipe.recipeName.randomElement() ?? "Pizzas 4 fromages", ingredients: recipeList.recipe.ingredientsList, image: recipeList.recipe.image[recipeList.recipe.index.randomElement()!]!)
        
        return cell
    }
}

extension RecipesTableViewController {
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .right)
        }
    }
}

