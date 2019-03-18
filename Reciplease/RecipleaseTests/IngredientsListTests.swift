//
//  IngredientsListTests.swift
//  RecipleaseTests
//
//  Created by Adrien Carvalot on 18/03/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import XCTest
@testable import Reciplease

class IngredientsListTests: XCTestCase {
    
    func testGivenAllHasOneElement_WhenCallingGetAllowedIngredients_ThenItShouldReturnAStringOfParameters() {
        var ingredientsList = IngredientsList()
        ingredientsList.append("Chicken")
        
        let ingredients = ingredientsList.getAllowedIngredients()
        
        XCTAssert(ingredients == "&allowedIngredient[]=Chicken")
    }
    
    func testAllSpecialsCaseInAppendFunc() {
        var ingredientsList = IngredientsList()
    
        ingredientsList.append(" Apple")
        ingredientsList.append("Lemon ")
        ingredientsList.append("")
    
        XCTAssert(ingredientsList.all == ["Apple", "Lemon"])
    }
}
