//
//  RecipeService.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 25/01/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class RecipeService {
    static let shared = RecipeService()
    
    private init() {}
    
    func getRecipes(for url: URL, callback: @escaping(Bool) -> Void) {
        Alamofire.request(url).responseJSON { (response) in
            guard response.result.isSuccess,
                let data = response.data else {
                    callback(false)
                    return
            }
            guard let recipeData = try? JSONDecoder().decode(RecipeResponse.self, from: data) else {
                callback(false)
                return
            }
            self.storeRecipes(for: recipeData)
            callback(true)
        }
    }
    
    private func storeRecipes(for recipeData: RecipeResponse) {
        for recipe in recipeData.matches {
            let imageUrl = self.modifyUrl(recipe.smallImageUrls[0])

            self.getImage(for: imageUrl) { (image) in
                guard let image = image else {
                    return
                }
                let recipe = Recipe(name: recipe.name, ingredients: recipe.ingredients, image: image, rating: recipe.rating,
                                    timeInSeconds: recipe.totalTimeInSeconds, id: recipe.id, url: nil, isFavorite: false)
                RecipesList.shared.central.append(recipe)
            }
        }
    }
    
    private func getImage(for url: URL, completionHandler: @escaping ((UIImage?) -> Void)) {
        let url = url
        
        Alamofire.request(url).responseImage { (response) in
            guard response.result.isSuccess,
                let image = response.result.value else {
                    completionHandler(nil)
                    return
            }
            completionHandler(image)
        }
    }
    
    private func modifyUrl(_ imageUrl: String) -> URL {
        var stringUrl = imageUrl
        stringUrl.removeLast(2)
        stringUrl.append("300")
        
        guard let url = URL(string: stringUrl) else {
            return URL(string: "Error")!
        }
        return url
    }
    
    func getUrl(for url: URL, callback: @escaping(Bool, URL?) -> Void) {
        Alamofire.request(url).responseJSON { (response) in
            guard response.result.isSuccess,
                let data = response.data else {
                    callback(false, nil)
                    return
            }
            guard let urlResponse = try? JSONDecoder().decode(URLResponse.self, from: data) else {
                callback(false, nil)
                return
            }
            let url = urlResponse.source.sourceRecipeUrl
            callback(true, url)
        }
    }
}

    // Decode getRecipes func response
fileprivate struct RecipeResponse: Decodable {
    let matches: [Matches]
}

fileprivate struct Matches: Decodable {
    let name: String
    let ingredients: [String]
    let totalTimeInSeconds: Int
    let rating: Int
    let smallImageUrls: [String]
    let id: String
    
    init(name: String, ingredients: [String], totalTimeInSeconds: Int, rating: Int, smallImageUrls: [String], id: String) {
        self.name = name
        self.ingredients = ingredients
        self.totalTimeInSeconds = totalTimeInSeconds
        self.rating = rating
        self.smallImageUrls = smallImageUrls
        self.id = id
    }
        
    enum MyStructKeys: String, CodingKey {
        case recipeName = "recipeName"
        case ingredients = "ingredients"
        case totalTimeInSeconds = "totalTimeInSeconds"
        case rating = "rating"
        case smallImageUrls = "smallImageUrls"
        case id = "id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyStructKeys.self)
        let recipeName: String = try container.decode(String.self, forKey: .recipeName)
        let ingredients: [String] = try container.decode([String].self, forKey: .ingredients)
        let totalTimeInSeconds: Int = try container.decode(Int.self, forKey: .totalTimeInSeconds)
        let rating: Int = try container.decode(Int.self, forKey: .rating)
        let smallImageUrls: [String] = try container.decode([String].self, forKey: .smallImageUrls)
        let id: String = try container.decode(String.self, forKey: .id)
        
        self.init(name: recipeName, ingredients: ingredients, totalTimeInSeconds: totalTimeInSeconds,
                  rating: rating, smallImageUrls: smallImageUrls, id: id)
    }
}

fileprivate struct URLResponse: Codable {
    let source: Source
}
fileprivate struct Source: Codable {
    let sourceRecipeUrl: URL
    let sourceDisplayName: String
}
