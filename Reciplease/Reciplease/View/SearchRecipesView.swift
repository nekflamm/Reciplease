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
    // -----------------------------------------------------------------
    //              MARK: - @IBOutlets
    // -----------------------------------------------------------------
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var ingredientsList: UITextView!
    @IBOutlet weak var introductoryLabel: UILabel!
    
    // -----------------------------------------------------------------
    //              MARK: - Properties
    // -----------------------------------------------------------------
    private var secondBanner = UIImageView()
    
    private let animationManager = AnimationManager()
    
    private var introIsActive = true
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
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
        animationManager.bannerAnim(banner: banner, secondBanner: secondBanner)
    }
    
    func scheduledTimerWithTimeInterval() {
        let scndBanner = animationManager.setupBanner(banner: banner, scndBanner: secondBanner)
        
        self.insertSubview(scndBanner, belowSubview: banner)
        _ = Timer.scheduledTimer(timeInterval: (6.0), target: self, selector: #selector(animate), userInfo: nil, repeats: true)
    }
}
