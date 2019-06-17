//
//  TodaysRecipe.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 08/02/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation
import UIKit

struct TodaysRecipe {
     var mealSelected = "Breakfast"
    
    mutating func setMeal(for tag: Int) {
        switch tag {
        case 0:
            mealSelected = "Breakfast"
        case 1:
            mealSelected = "Lunch"
        case 2:
            mealSelected = "TeaTime"
        case 3:
            mealSelected = "Dinner"
        default:
            break
        }
    }
}
