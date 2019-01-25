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
    
    private let imageArray = [UIImage(named: "pizza"), UIImage(named: "couscous"),
                                                   UIImage(named: "sushis"), UIImage(named: "pates"),
                                                   UIImage(named: "poivrons"), UIImage(named: "fruits")]
    private var index = 0
    private var introIsActive = true
    
    func scheduledTimerWithTimeInterval() {
        _ = Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(animImage), userInfo: nil, repeats: true)
    }
    
    func addIngredient(_ ingredient: String) {
        if introIsActive {
            introductoryLabel.isHidden = true
        }
        ingredientsList.text += "• \(ingredient)\n"
        cleanTextField()
    }
    
    @objc private func animImage() {
        UIView.transition(with: banner, duration: 1.5, options: .transitionCrossDissolve, animations: {
            self.banner.image = self.imageArray[self.checkIndex()]
        }, completion: nil)
    }
    
    private func cleanTextField() {
        ingredientsTextField.text = nil
    }
    
    func cleanTextView() {
        introductoryLabel.isHidden = false
        ingredientsList.text = nil
    }
    
    private func checkIndex() -> Int {
        index += 1
        if index == imageArray.count {
            index = 0
        }
        return index
    }
}
