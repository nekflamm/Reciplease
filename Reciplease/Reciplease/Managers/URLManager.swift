//
//  URLManager.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 14/03/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation
import UIKit

struct URLManager {
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    static func getSearchURL(with ingredients: String) -> URL {
        let url = URL(string: "https://api.yummly.com/v1/api/recipes?_app_id=d2db4f54&_app_key=3d9d9071094ba629125874ebdfc836d8&requirePictures=true\(ingredients)&maxResult=50")
        
        return url!
    }
    
    static func getWebPageURL(with id: String) -> URL {
        let url = URL(string: "http://api.yummly.com/v1/api/recipe/\(id)?_app_id=d2db4f54&_app_key=3d9d9071094ba629125874ebdfc836d8")
        
        return url!
    }
    
    static func getTodaysURL(with meal: String) -> URL {
        let url = URL(string: "https://api.yummly.com/v1/api/recipes?_app_id=d2db4f54&_app_key=3d9d9071094ba629125874ebdfc836d8&requirePictures=true&q=\(meal)&maxResult=35")
        
        return url!
    }
}
