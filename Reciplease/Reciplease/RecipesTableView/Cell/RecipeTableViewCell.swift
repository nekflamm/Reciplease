//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 27/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation
import UIKit

class RecipeTableViewCell: UITableViewCell {
    // -----------------------------------------------------------------
    //              MARK: - @IBOutlets
    // -----------------------------------------------------------------
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    func configure(with recipe:  Recipe) {
        recipeNameLabel.text = recipe.name
        ingredientsLabel.text = recipe.followingIngredients
        cellImageView.image = recipe.image
        ratingLabel.text = String(recipe.rating)
        timeLabel.text = "\(String(recipe.timeInSeconds / 60))m"
    }
}
