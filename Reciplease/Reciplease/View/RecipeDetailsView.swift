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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    func setup(title: String, ingredients: String, image: UIImage) {
        titleLabel.text = title
        ingredientsTextView.text = ingredients
        imageView.image = image
    }
}
