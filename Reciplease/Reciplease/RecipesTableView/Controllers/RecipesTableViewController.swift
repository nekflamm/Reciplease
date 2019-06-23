//
//  RecipesTableViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 24/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit

class RecipesTableViewController: UITableViewController {
    // -----------------------------------------------------------------
    //              MARK: - Properties
    // -----------------------------------------------------------------
    var recipes: [Recipe]?
    var titleName: String?
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        navigationController?.title = titleName
    }
    
    // -----------------------------------------------------------------
    //              MARK: - TableView methods
    // -----------------------------------------------------------------
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "RecipeCell")
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)  as? RecipeTableViewCell,
            let recipe = recipes?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(with: recipe)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let recipe = recipes?[indexPath.row],
            let recipeDetailsVC = UIStoryboard(name: "RecipeDetails", bundle: nil).instantiateInitialViewController() as? RecipeDetailsViewController else {
            return
        }

        recipeDetailsVC.recipe = recipe
        
        push(recipeDetailsVC)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
}
