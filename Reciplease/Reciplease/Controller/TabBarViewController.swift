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
    
    var selectedItem = 0
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            RecipesList.shared.key = "search"
        case 1:
            RecipesList.shared.key = "favorite"
        case 2:
            RecipesList.shared.key = "today"
        default:
            print("Error")
        }
    }
    
//    func setValue(tag: Int) {
//        selectedItem = tag
//        print("Page changed for \(selectedItem)")
//    }
//
//    func getString() -> String {
//        switch selectedItem {
//        case 0:
//            return "search"
//        case 1:
//            return "favorite"
//        case 2:
//            return "today"
//        default:
//            return "error"
//        }
//    }
}
