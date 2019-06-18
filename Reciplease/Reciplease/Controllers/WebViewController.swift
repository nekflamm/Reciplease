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
    //              MARK: - Properties / @IBOutlets
    // -----------------------------------------------------------------
    @IBOutlet weak var webView: WKWebView!
    
    var recipeID: String?
    
    private var url: URL? {
        if let id = recipeID,
            let appID = Constants.APIKeys.all["AppID"],
            let appKey = Constants.APIKeys.all["AppKey"],
            let url = URL(string: "http://api.yummly.com/v1/api/recipe/\(id)?_app_id=\(appID)&_app_key=\(appKey)") {
            
            return url
        }
        
        return nil
    }
    
    // -----------------------------------------------------------------
    //              MARK: - Methods
    // -----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRequest()
    }
    
    private func loadRequest() {
        guard let url = url else {
            return
        }
        
        RecipeService.shared.getWebPageUrl(for: url) { (success, url) in
            guard let webPageURL = url else {
                return
            }
            
            self.webView.load(URLRequest(url: webPageURL))
        }
    }
}
