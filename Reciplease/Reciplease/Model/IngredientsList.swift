//
//  IngredientsList.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 25/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation

struct IngredientsList {
    static var all = [String]()
    
    static func array() -> [String] {
        var array = [String]()
        
        for ingredient in all {
            array.append("allowedIngredient[]=\(ingredient)&")
        }
        return array
    }
}
