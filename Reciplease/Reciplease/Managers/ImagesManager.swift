//
//  ImagesManager.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 27/02/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation

class ImagesManager {
    // -----------------------------------------------------------------
    //              MARK: - Properties
    // -----------------------------------------------------------------
    private var imagesNames: [String] {
        return createImagesNamesArray(number: 12, name: "Meal")
    }
    
    private var index = 0
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    
    // Create images names array with an imageName and the imagesNumber
    private func createImagesNamesArray(number: Int, name: String) -> [String] {
        var imagesNames = [String]()

        for number in 1...number {
            imagesNames.append("\(name)\(number)")
        }
        return imagesNames
    }
    
    // Return an imageName
    func takeAnImageName() -> String {
        checkIndex()
        
        let imageName = imagesNames[index]
        index += 1
        
        return imageName
    }
    
    // Reset index if needed
    private func checkIndex() {
        if index >= imagesNames.count {
            index = 0
        }
    }
}
