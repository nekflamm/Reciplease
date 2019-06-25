//
//  StringExtension.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 23/06/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation

extension String {
    func formatted() -> String? {
        let trimedIngredient = self.trimmingCharacters(in: .whitespacesAndNewlines)
        let formattedIngredient = trimedIngredient.replacingOccurrences(of: " ", with: "+")
        
        if formattedIngredient != "" {
            return formattedIngredient
        }
        
        return nil
    }
}
