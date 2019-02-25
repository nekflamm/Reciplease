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
    
    let animManager = AnimationManager()
    
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
    
    private func clearTextField() {
        ingredientsTextField.text = nil
    }
    
    @objc private func animate() {
        animManager.launchAnimation(banner: banner, secondBanner: secondBanner)
    }
    
    func scheduledTimerWithTimeInterval() {
        animManager.setupBanners(banner: banner, secondBanner: secondBanner, view:  self)
        _ = Timer.scheduledTimer(timeInterval: (6.0), target: self, selector: #selector(animate), userInfo: nil, repeats: true)
    }
}



//    @objc private func animImage() {
//        UIView.transition(with: banner, duration: 1.5, options: .transitionCrossDissolve, animations: {
//            self.banner.image = self.imageArray[self.checkIndex()]
//        }, completion: nil)
//    }

//
//
//
//

//    private let imageArray = [UIImage(named: "pizza"), UIImage(named: "couscous"),
//                              UIImage(named: "sushis"), UIImage(named: "pates"),
//                              UIImage(named: "poivrons"), UIImage(named: "fruits")]
//
//    private var index = 0
//
//    func newScheduledTimerWithTimeInterval() {
//        _ = Timer.scheduledTimer(timeInterval: (6.0), target: self, selector: #selector(launchAnimation), userInfo: nil, repeats: true)
//    }
//
//    @objc private func launchAnimation() {
//        let x = -banner.frame.width
//
//        UIView.animate(withDuration: 2.0, delay: 2, animations: {
//            self.banner.transform = CGAffineTransform(translationX: x, y: 0)
//            self.secondBanner.transform = CGAffineTransform(translationX: x, y: 0)
//        }) { (success) in
//            self.banner.image = self.imageArray[self.checkIndex()]
//            swap(&self.banner.image, &self.secondBanner.image)
//            self.banner.transform = .identity
//            self.secondBanner.transform = .identity
//        }
//    }
//
//    func setupBanners() {
//        banner.accessibilityIdentifier = "banner"
//        secondBanner.accessibilityIdentifier = "scndBanner"
//        secondBanner.image = imageArray[checkIndex()]
//        secondBanner.image = UIImage(named: "pates")
//        secondBanner.frame = CGRect(x: banner.frame.maxX, y: banner.frame.minY, width: banner.frame.width, height: banner.frame.height)
//        secondBanner.contentMode = .scaleAspectFill
//        secondBanner.clipsToBounds = true
//
//        self.insertSubview(secondBanner, belowSubview: banner)
//    }
//
//    private func checkIndex() -> Int {
//        index += 1
//        if index == imageArray.count {
//            index = 0
//        }
//        return index
//    }
