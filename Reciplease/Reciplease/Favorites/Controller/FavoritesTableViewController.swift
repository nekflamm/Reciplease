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
    // -----------------------------------------------------------------
    //              MARK: - Properties
    // -----------------------------------------------------------------
    var selectedRecipe: Recipe?
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // Remove recipe selected from context
    private func removeFromContext(at index: Int) {
        AppDelegate.viewContext.delete(RecipeData.all[index])
        try? AppDelegate.viewContext.save()
    }
    
    // -----------------------------------------------------------------
    //              MARK: - TableView methods
    // -----------------------------------------------------------------
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecipeData.all.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "RecipeCell")
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)  as? RecipeTableViewCell,
            let recipe = RecipeData.dataToRecipe(for: indexPath.row) else {
                print("Fail to create favorite cell")
            return UITableViewCell()
        }
        
        let imageView = UIImageView()
        imageView.kf.setImage(with: getImageURL(for: recipe))
        
        cell.configure(with: recipe, and: imageView)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let recipe = RecipeData.dataToRecipe(for: indexPath.row),
            let recipeDetailsVC = UIStoryboard(name: "RecipeDetails", bundle: nil).instantiateInitialViewController() as? RecipeDetailsViewController else {
            return
        }
        
        recipeDetailsVC.recipe = recipe

        push(recipeDetailsVC)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        removeFromContext(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .right)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
}
