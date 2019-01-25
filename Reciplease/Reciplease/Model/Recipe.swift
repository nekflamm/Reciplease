//
//  Recipe.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 25/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation

protocol Recipe {
    var title: String { get }
    var ingredients: [String] { get }
    var note: Int { get }
    var timeInSeconds: Int { get }
}
