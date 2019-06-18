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
    // -----------------------------------------------------------------
    //              MARK: - Properties
    // -----------------------------------------------------------------
    var imagesManager = ImagesManager()
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    func bannerAnim(banner: UIImageView, secondBanner: UIImageView) {
        let x = -banner.frame.width
        
        UIView.animate(withDuration: 2.0, delay: 2.0, animations: {
            banner.transform = CGAffineTransform(translationX: x, y: 0)
            secondBanner.transform = CGAffineTransform(translationX: x, y: 0)
        }) { (success) in
            banner.image = UIImage(named: self.imagesManager.takeAnImageName())
            swap(&banner.image, &secondBanner.image)
            banner.transform = .identity
            secondBanner.transform = .identity
        }
    }
    
    func setupBanner(banner: UIImageView, scndBanner: UIImageView) -> UIImageView {
        scndBanner.image = UIImage(named: imagesManager.takeAnImageName())
        scndBanner.frame = CGRect(x: banner.frame.maxX, y: banner.frame.minY, width: banner.frame.width, height: banner.frame.height)
        scndBanner.contentMode = .scaleAspectFill
        scndBanner.clipsToBounds = true
        
        return scndBanner
    }
    
    func todaysPageAnim(for views: [UIView], with translation: CGFloat) {
        var index = views.count
        var delay: Double = 0.2
        let translationY = -translation
        
        for view in views {
            view.transform = CGAffineTransform(translationX: 0, y: translationY)
        }
        
        while index != 0 {
            UIView.animate(withDuration: 0.6, delay: delay, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.85, options: [], animations: {
                views[index - 1].transform = .identity
            })
            index -= 1
            delay += 0.3
        }
    }
}
