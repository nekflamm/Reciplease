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
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(name: String, ingredients: String, image: UIImage, rating: String, time: String) {
        recipeNameLabel.text = name
        ingredientsLabel.text = ingredients
        cellImageView.image = image
        ratingLabel.text = rating
        timeLabel.text = time
    }
}
