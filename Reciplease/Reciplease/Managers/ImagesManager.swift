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
        return createArray(number: 12, name: "Meal")
    }
    
    private var index = 0
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    private func createArray(number: Int, name: String) -> [String] {
        var imagesNames = [String]()
        
        for number in 1...number {
            imagesNames.append("\(name)\(number)")
        }
        return imagesNames
    }
    
    func takeAnImageName() -> String {
        checkIndex()
        
        let imageName = imagesNames[index]
        index += 1
        
        return imageName
    }
    
    private func checkIndex() {
        if index >= imagesNames.count {
            index = 0
        }
    }
}
