//
//  TodaysRecipeTests.swift
//  RecipleaseTests
//
//  Created by Adrien Carvalot on 18/03/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import XCTest
@testable import Reciplease

class TodaysRecipeTests: XCTestCase {
    
    func testGivenMealSelectedIsBreakfast_WhenCallingSetMealForTag0_ThenMealSelectedShouldntBeChange() {
        var todaysRecipe = TodaysRecipe()
        
        todaysRecipe.setMeal(for: 0)
        
        XCTAssert(todaysRecipe.mealSelected == "Breakfast")
    }
    
    func testGivenMealSelectedIsBreakfast_WhenCallingSetMealForTag1_ThenMealSelectedShouldBeLunch() {
        var todaysRecipe = TodaysRecipe()
        
        todaysRecipe.setMeal(for: 1)
        
        XCTAssert(todaysRecipe.mealSelected == "Lunch")
    }
    
    func testGivenMealSelectedIsBreakfast_WhenCallingSetMealForTag2_ThenMealSelectedShouldBeTeaTime() {
        var todaysRecipe = TodaysRecipe()
        
        todaysRecipe.setMeal(for: 2)
        
        XCTAssert(todaysRecipe.mealSelected == "TeaTime")
    }
    
    func testGivenMealSelectedIsBreakfast_WhenCallingSetMealForTag3_ThenMealSelectedShouldBeDinner() {
        var todaysRecipe = TodaysRecipe()
        
        todaysRecipe.setMeal(for: 3)
        
        XCTAssert(todaysRecipe.mealSelected == "Dinner")
    }
    
    func testGivenMealSelectedIsBreakfast_WhenCallingSetMealForTag5_ThenItShouldEnterInDefaultCaseAndMealSelectedShouldntBeChange() {
        var todaysRecipe = TodaysRecipe()
        
        todaysRecipe.setMeal(for: 5)
        
        XCTAssert(todaysRecipe.mealSelected == "Breakfast")
    }
}
