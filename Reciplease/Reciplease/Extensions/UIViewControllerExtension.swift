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
    func displayAlert(title: String, message: String) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    
    func getInitialImageURL(for recipeData: RecipeInfos) -> URL {
        var imageURL = URL(string: Constants.URL.defaultImageURL)!
        
        if let firstImageURL = recipeData.smallImageUrls?.first {
            imageURL = modifyImageSizeUrl(firstImageURL)
        }
        
        return imageURL
    }
    
    // Remove the two lasts caracters and replace it by the iphone's width size
    func modifyImageSizeUrl(_ imageUrl: String) -> URL {
        guard let modifyedURL = URL(string: imageUrl.replacingOccurrences(of: "=s90", with: "=s\((String(Int(Double(self.view.frame.width)))))")) else {
            return URL(string: "Error")!
        }
        
        return modifyedURL
    }
}
