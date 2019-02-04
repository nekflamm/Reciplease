//
//  Favorite.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 30/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation
import UIKit

protocol List {
    static var recipes: [Recipe] { get set }
}

struct Favorite: List {
    static var recipes =  [Recipe]()
}
