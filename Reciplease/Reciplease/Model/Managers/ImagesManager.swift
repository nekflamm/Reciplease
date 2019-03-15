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
    // -----------------------------------------------------------------
    //              MARK: - Properties
    // -----------------------------------------------------------------
    private var images: [UIImage] {
        return createArray(number: 10, name: "Meal")
    }
    private var index = 0
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    mutating func takeAnImage() -> UIImage {
        checkIndex()
        
        let image = images[index]
        index += 1
        
        return image
    }
    
    mutating private func checkIndex() {
        if index >= images.count {
            index = 0
        }
    }
        
    private func createArray(number: Int, name: String) -> [UIImage] {
        var images = [UIImage]()
        var imageNumber = 1
        
        for _ in 1...number {
            images.append(UIImage(named: "\(name)\(imageNumber)")!)
            imageNumber += 1
        }
        return images
    }
}
