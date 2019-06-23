//
//  UIViewControllerExtension.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 21/05/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    // -----------------------------------------------------------------
    //              MARK: - Alerts
    // -----------------------------------------------------------------
    func displayAlert(title: String, message: String) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    // -----------------------------------------------------------------
    //              MARK: - URL Management
    // -----------------------------------------------------------------
    
    // Get image url if possible, else set default image
    func getImageURL(for recipeData: RecipeInfos) -> URL {
        var imageURL = URL(string: Constants.URL.defaultImageURL)!

        if let firstImageURL = recipeData.smallImageUrls?.first {
            imageURL = modifyImageSizeUrl(firstImageURL)
        }
        
        return imageURL
    }

    
    // Remove the two lasts caracters and replace it by the iphone's width size
    private func modifyImageSizeUrl(_ imageUrl: String) -> URL {
        guard let modifyedURL = URL(string: imageUrl.replacingOccurrences(of: "=s90", with: "=s\((String(Int(Double(self.view.frame.width)))))")) else {
            
            return URL(string: "Error")!
        }
        
        return modifyedURL
    }
    
    func push(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
