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
    //              MARK: - Methods
    // -----------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRequest()
    }
    
    private func loadRequest() {
        guard let url = RecipesList.shared.selectedRecipes[RecipesList.shared.key]?.url else {
            return
        }
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
}
