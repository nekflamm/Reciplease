//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 27/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(recipeName: String, ingredients: String, image: UIImage, rating: String, time: String) {
        recipeNameLabel.text = recipeName
        ingredientsLabel.text = ingredients
        cellImageView.image = image
        ratingLabel.text = rating
        timeLabel.text = time
    }
}
