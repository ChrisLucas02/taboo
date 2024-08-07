//
//  Team.swift
//  Taboo
//
//  Created by Chris Lucas on 25.10.21.
//  Copyright © 2020 HEIA-FR INFO. All rights reserved.
//

import Foundation

class Team {
    
    var name: String
    var score: Int
    
    init(name: String) {
        self.name = name
        score = 0
    }
    
    func getScore() -> Int {
        return score
    }
    
    func incrementScore() {
        score += 1
    }
}
