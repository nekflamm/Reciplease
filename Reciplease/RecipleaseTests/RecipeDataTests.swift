//
//  RecipeDataTests.swift
//  RecipleaseTests
//
//  Created by Adrien Carvalot on 18/03/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import XCTest
@testable import Reciplease

class RecipeDataTests: XCTestCase {
    
    func testGivenAllIsNotEmpty_WhenCallingDataToRecipe_ThenItShouldReturnARecipe() {
        guard let recipe = RecipeData.dataToRecipe(for: 0) else {
            return
        }
        XCTAssertNotNil(recipe)
    }
}
