//
//  ImagesManager.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 27/02/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation
import UIKit

struct ImagesManager {
    
    private var all = [String: [UIImage]]()
    
    init() {
        all = createAllArrays()
    }
    
    func takeAnImage(for name: String, withPrevious image: UIImage) -> UIImage? {
        for (arrayName, imageArray) in all {
            if name == arrayName {
                let newImage = imageArray.randomElement()
                
                if newImage == image {
                    return takeAnImage(for: name, withPrevious: image)
                }
                return imageArray.randomElement()
            }
        }
        return nil
    }
    
    func createArray(number: Int, name: String) -> [UIImage] {
        var images = [UIImage]()
        var imageNumber = 1
        
        for _ in 1...number {
            images.append(UIImage(named: "\(name)\(imageNumber)")!)
            imageNumber += 1
        }
        return images
    }
    
    func createAllArrays() -> [String: [UIImage]] {
        let meals = createArray(number: 10, name: "Meal")
        let breakfast = createArray(number: 2, name: "Breakfast")
        let dinner = createArray(number: 5, name: "Dinner")
        let lunch = createArray(number: 5, name: "Lunch")
        let teaTime = createArray(number: 3, name: "TeaTime")
        
        let all = ["Meal": meals, "Breakfast": breakfast, "Dinner":
            dinner, "Lunch": lunch, "TeaTime": teaTime]
        
        return all
    }
}
