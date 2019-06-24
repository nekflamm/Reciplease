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
    func configure(with recipe:  Recipe, and imageView: UIImageView) {
        if let time = recipe.totalTimeInSeconds {
            timeLabel.text = "\(String(time / 60))m"
        }
        recipeNameLabel.text = recipe.recipeName
        ingredientsLabel.text = recipe.followingIngredients
        cellImageView.image = imageView.image
        ratingLabel.text = String(recipe.rating)
//        timeLabel.text = "\(String(recipe.totalTimeInSeconds! / 60))m"
    }
}
