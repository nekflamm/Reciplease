//
//  SearchRecipesView.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 24/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation
import UIKit

class SearchRecipesView: UIView {
    
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var ingredientsList: UITextView!
    @IBOutlet weak var introductoryLabel: UILabel!
    var secondBanner = UIImageView()
    
    let animationManager = AnimationManager()
    
    private var introIsActive = true
    
    func addIngredient(_ ingredient: String) {
        if introIsActive {
            introductoryLabel.isHidden = true
        }
        ingredientsList.text += "• \(ingredient)\n\n"
        clearTextField()
    }
    
    func clearTextView() {
        introductoryLabel.isHidden = false
        ingredientsList.text = nil
    }
    
    func resignResponder() {
        ingredientsTextField.resignFirstResponder()
    }
    
    func clearTextField() {
        ingredientsTextField.text = nil
    }
    
    @objc private func animate() {
        animationManager.animate(banner: banner, secondBanner: secondBanner, imagesNames: "Meal", delay: 2.0, check: banner.image!)
    }
    
    func scheduledTimerWithTimeInterval() {
        self.insertSubview(animationManager.setupBanner(view: nil, banner: banner, scndBanner: secondBanner, images: "Meal", check: banner.image!, addToY: 0), belowSubview: banner)
        _ = Timer.scheduledTimer(timeInterval: (6.0), target: self, selector: #selector(animate), userInfo: nil, repeats: true)
    }
}
