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
    let imagesManager = ImagesManager()
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    func animate(banner: UIImageView, secondBanner: UIImageView, imagesNames: String, delay: Double, check previousImage: UIImage) {
        let x = -banner.frame.width
        
        UIView.animate(withDuration: 2.0, delay: delay, animations: {
            banner.transform = CGAffineTransform(translationX: x, y: 0)
            secondBanner.transform = CGAffineTransform(translationX: x, y: 0)
        }) { (success) in
            banner.image = self.imagesManager.takeAnImage(for: imagesNames, withPrevious: previousImage)
            swap(&banner.image, &secondBanner.image)
            banner.transform = .identity
            secondBanner.transform = .identity
        }
    }
    
    func setupBanner(view: UIView?, banner: UIImageView?, scndBanner: UIImageView, images: String, check previousImage: UIImage, addToY y: CGFloat) -> UIImageView {
        let object = getObject(for: view, and: banner)
        
        scndBanner.image = imagesManager.takeAnImage(for: images, withPrevious: previousImage)
        scndBanner.frame = CGRect(x: object.frame.maxX, y: object.frame.minY + y, width: object.frame.width, height: object.frame.height)
        scndBanner.contentMode = .scaleAspectFill
        scndBanner.clipsToBounds = true
        
        return scndBanner
    }
    
    private func getObject(for view: UIView?, and banner: UIImageView?) -> AnyObject {
        var object: AnyObject = UIImage()
        
        guard view != nil, let view = view else {
            object = banner!
            
            return object
        }
        object = view
        
        return object
    }
}
