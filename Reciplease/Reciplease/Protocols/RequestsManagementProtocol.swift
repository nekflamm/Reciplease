//
//  RequestsProtocol.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 21/06/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation
import UIKit

protocol RequestsManagement: UIViewController {
    var requestsQueue: [Request] { get set }
    var recipesManager: RecipesManager { get set }
    
    func goToNextPage()
}

extension RequestsManagement {
    func fillRequestsQueue(withNumber number: Int) {
        for _ in 0..<number {
            self.requestsQueue.append(Request())
        }
    }
    
    func launchImagesRequests(withData recipesInfos: [RecipeInfos]) {
        if !isAllRequestsDone() {
            for (index, request) in requestsQueue.enumerated() {
                if request.state == .waiting && (requestsQueue.filter{ $0.state == .inProgress }).count == 0 {
                    getImageAndStoreRecipe(for: recipesInfos, at: index)
                }
            }
        } else {
            goToNextPage()
        }
    }
    
    private func isAllRequestsDone() -> Bool {
        return (requestsQueue.filter { $0.state == .done}).count == (requestsQueue.filter {$0.state != .failed}).count
    }
    
    // Get recipes images and store recipes
    private func getImageAndStoreRecipe(for recipesData: [RecipeInfos], at index: Int) {
        requestsQueue[index].state = .inProgress
        
        RecipeService.shared.getImage(for: getImageURL(for: recipesData[index])) { (image) in
            guard let image = image else {
                self.requestsQueue[index].state = .failed
                return
            }
            
            self.recipesManager.fillRecipe(with: self.recipesManager.convertDataToRecipe(withData: recipesData[index], and: image))
            self.requestsQueue[index].state = .done
            
            self.launchImagesRequests(withData: recipesData)
        }
    }
    
    func resetRequestsQueue() {
        self.requestsQueue.removeAll()
    }
}
