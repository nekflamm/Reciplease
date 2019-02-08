//
//  MealsView.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 07/02/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation
import UIKit

class MealsView: UIView {
    @IBOutlet var selectedImages: [UIImageView]!
    
    func selectImage(for index: Int) {
        for image in selectedImages {
            image.image = UIImage(named: "notSelected")
        }
        selectedImages[index].image = UIImage(named: "selected")
    }
}
