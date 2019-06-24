//
//  WebViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 20/02/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    // -----------------------------------------------------------------
    //              MARK: - @IBOutlets
    // -----------------------------------------------------------------
    @IBOutlet weak var webView: WKWebView!
    
    // -----------------------------------------------------------------
    //              MARK: - Properties
    // -----------------------------------------------------------------
    var recipeID: String?
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRequest()
    }
    
    private func loadRequest() {
        guard let recipeID = recipeID else {
            return displayAlert(title: "Error.", message: "Recipe hasn't an ID.")
        }
        
        RecipeService.shared.getRecipeWebPageUrl(for: recipeID) { [weak self] (success, url) in
            guard success, let webPageURL = url else {
                return self?.displayAlert(title: "Error.", message: "Fail to get web page url.") ?? ()
            }
            
            self?.webView.load(URLRequest(url: webPageURL))
        }
    }
}
