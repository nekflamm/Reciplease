//
//  AnimationsManager.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 23/02/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation
import UIKit

class AnimationManager {
    private let imageArray = [UIImage(named: "pizza"), UIImage(named: "couscous"),
                              UIImage(named: "sushis"), UIImage(named: "pates"),
                              UIImage(named: "poivrons"), UIImage(named: "fruits")]
    
    private var index = 0
    
    func launchAnimation(banner: UIImageView, secondBanner: UIImageView) {
        let x = -banner.frame.width
        
        UIView.animate(withDuration: 2.0, delay: 2, animations: {
            banner.transform = CGAffineTransform(translationX: x, y: 0)
            secondBanner.transform = CGAffineTransform(translationX: x, y: 0)
        }) { (success) in
            banner.image = self.imageArray[self.checkIndex()]
            swap(&banner.image, &secondBanner.image)
            banner.transform = .identity
            secondBanner.transform = .identity
        }
    }
    
    func setupBanners(banner: UIImageView, secondBanner: UIImageView, view: UIView) {
        banner.accessibilityIdentifier = "banner"
        secondBanner.accessibilityIdentifier = "scndBanner"
        secondBanner.image = imageArray[checkIndex()]
        secondBanner.image = UIImage(named: "pates")
        secondBanner.frame = CGRect(x: banner.frame.maxX, y: banner.frame.minY, width: banner.frame.width, height: banner.frame.height)
        secondBanner.contentMode = .scaleAspectFill
        secondBanner.clipsToBounds = true
        
        view.insertSubview(secondBanner, belowSubview: banner)
    }
    
    private func checkIndex() -> Int {
        index += 1
        if index == imageArray.count {
            index = 0
        }
        return index
    }
}
