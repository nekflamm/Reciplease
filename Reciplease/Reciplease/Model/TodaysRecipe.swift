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
    // -----------------------------------------------------------------
    //              MARK: - Properties
    // -----------------------------------------------------------------
     var mealSelected = "Breakfast"
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
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
    
//    func getURL() -> URL? {
//        guard let url = URL(string: "https://api.yummly.com/v1/api/recipes?_app_id=d2db4f54&_app_key=3d9d9071094ba629125874ebdfc836d8&requirePictures=true&q=\(mealSelected)&maxResult=75") else {
//            return nil
//        }
//        return url
//    }
}
