//
//  Request.swift
//  Reciplease
//
//  Created by Adrien Carvalot on 21/06/2019.
//  Copyright © 2019 Adrien Carvalot. All rights reserved.
//

import Foundation

struct Request {
    
    enum State {
        case waiting
        case inProgress
        case done
        case failed
    }
    
    var state: State = .waiting
}
