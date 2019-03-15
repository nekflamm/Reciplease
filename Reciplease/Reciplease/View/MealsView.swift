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
    // -----------------------------------------------------------------
    //              MARK: - @IBOutlets
    // -----------------------------------------------------------------
    @IBOutlet var selectedImages: [UIImageView]!
    @IBOutlet var bannersImages: [UIImageView]!
    @IBOutlet var bannersView: [UIView]!
    
    // -----------------------------------------------------------------
    //              MARK: - Properties
    // -----------------------------------------------------------------
    private let animationManager = AnimationManager()
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    func selectImage(for index: Int) {
        for image in selectedImages {
            image.image = UIImage(named: "notSelected")
        }
        selectedImages[index].image = UIImage(named: "selected")
    }
    
    func animate() {
        let translation = UIScreen.main.bounds.height
        animationManager.todaysPageAnim(for: bannersView, with: translation)
    }
}
