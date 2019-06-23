//
//  IngredientTableViewCell.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 23/06/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    @IBOutlet weak var ingredientLabel: UILabel!
    
    func configure(with ingredient: String) {
        self.layer.backgroundColor = UIColor.clear.cgColor
        
        ingredientLabel.text = ingredient
    }
}
