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
    
    private var secondaryImages = [UIImageView(), UIImageView(), UIImageView(), UIImageView()]
    
    private let animationManager = AnimationManager()
    
    private let names = ["Breakfast", "Lunch", "TeaTime", "Dinner"]
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    
    func selectImage(for index: Int) {
        for image in selectedImages {
            image.image = UIImage(named: "notSelected")
        }
        selectedImages[index].image = UIImage(named: "selected")
    }
    
    func scheduledTimerWithTimeInterval() {
        setupBanners()
        _ = Timer.scheduledTimer(timeInterval: (6.0), target: self, selector: #selector(launchAnim), userInfo: nil, repeats: true)
    }
    
    @objc private func launchAnim() {
        var index = 0
        var delay = 2.0
        
        for name in names {
            animationManager.animate(banner: bannersImages[index], secondBanner: secondaryImages[index], imagesNames: name, delay: delay, check: bannersImages[index].image!)
            
            index += 1
            delay += 0.4
        }
    }
    
    private func setupBanners() {
        var index = 0
        
        for name in names {
            let banner = animationManager.setupBanner(view: bannersView[index], banner: nil, scndBanner: secondaryImages[index], images: name, check: bannersImages[index].image!, addToY: 15)
            self.insertSubview(banner, belowSubview: bannersImages[index])
            
            index += 1
        }
    }
}
