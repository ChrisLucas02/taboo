//
//  Taboo.swift
//  Taboo
//
//  Created by Chris Lucas on 25.10.21.
//  Copyright © 2020 HEIA-FR INFO. All rights reserved.
//

import Foundation

class Taboo {
    
    var word: String
    var taboos: [String]
    var state: CardState
    
    init(word: String, taboos: [String]) {
        self.word = word
        self.taboos = taboos
        self.state = .passed
    }
}
