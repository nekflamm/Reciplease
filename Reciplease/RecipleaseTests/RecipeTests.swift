//
//  RecipeTests.swift
//  RecipleaseTests
//
//  Created by Adrien Carvalot on 18/03/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import XCTest
@testable import Reciplease

class RecipeTests: XCTestCase {
    
    func testGivenOneRecipeIsCreated_WhenGettingIngredientsList_ThenItShouldReturnAListOfIngredients() {
        let recipe = createRecipe()
        
        XCTAssert(recipe.ingredientsList == "Chicken, Cheddar.")
    }
    
    func testGivenOneRecipeIsCreated_WhenGettingTimeToString_ThenItShouldReturnATimeInMinutes() {
        let recipe = createRecipe()
        
        XCTAssert(recipe.timeToString == "60m")
    }
    
    func testGivenOneRecipeIsCreated_WhenGettingRatingToString_ThenItShouldReturnRatingConvertToString() {
        let recipe = createRecipe()
        
        XCTAssert(recipe.ratingToString == "3")
    }
    
    private func createRecipe() -> Recipe {
        let name = "Chicken"
        let ingredients = ["Chicken", "Cheddar"]
        let image = UIImage(named: "Meal1")!
        let rating = 3
        let time = 3600
        let id = ""
        let url = URL(string: "url")
        let favorite = true
        let recipe = Recipe(name: name, ingredients: ingredients, image: image, rating: rating, timeInSeconds: time, id: id, url: url, isFavorite: favorite)
        
        return recipe
    }
}
