//
//  Die.swift
//  Liars Dice
//
//  Created by Robert Giesler on 06.08.22.
//

import Foundation

class Die {
    var face: Face
    
    func roll() {
        self.face = Face(rawValue: Int.random(in: 1..<7))!
    }
    
    init() {
        self.face = Face(rawValue: Int.random(in: 1..<7))!
    }
}
