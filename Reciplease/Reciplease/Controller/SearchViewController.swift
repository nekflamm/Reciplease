//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 24/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    
    @IBOutlet weak var searchRecipesView: SearchRecipesView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchRecipesView.scheduledTimerWithTimeInterval()
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        addIngredientsToList()
    }
    
    private func addIngredientsToList() {
        guard let ingredient = searchRecipesView.ingredientsTextField.text  else {
            return
        }
        searchRecipesView.addIngredient(ingredient)
        IngredientsList.all.append(ingredient)
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        searchRecipesView.cleanTextView()
        IngredientsList.all.removeAll()
    }
}
