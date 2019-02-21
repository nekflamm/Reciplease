//
//  TabBarViewController.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 11/02/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    static let shared = TabBarViewController()
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            print("Going to search page")
            RecipesList.shared.key = "search"
        case 1:
            print("Going to favorite page")
            RecipesList.shared.key = "favorite"
        case 2:
            print("Going to today page")
            RecipesList.shared.key = "today"
        default:
            print("Error")
        }
    }
}
