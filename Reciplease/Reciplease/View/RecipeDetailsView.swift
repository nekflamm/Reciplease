//
//  RecipeDetailsView.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 28/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation
import UIKit

class RecipeDetailsView: UIView {
    // -----------------------------------------------------------------
    //              MARK: - @IBOutlets
    // -----------------------------------------------------------------
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    func setup(title: String, ingredients: String, image: UIImage, rate: String, time: String) {
        titleLabel.text = title
        ingredientsTextView.text = ingredients
        imageView.image = image
        rateLabel.text = rate
        timeLabel.text = time
    }
}
