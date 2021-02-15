//
//  NameGenerator.swift
//  Cardsneak
//
//  Created by Cameron Grigoriadis on 2/8/21.
//

import Foundation

class NameGenerator {
    
    private let names = ["Hustler", "Alec Alafonzo", "Wilomina", "Marquette", "Risley", "Enric", "Jarcous", "Brach Miller"]
    
    private lazy var pool = { names }()
    
    private var overflow = 0
    
    
    func generate() -> String {
        if let index = pool.indices.randomElement() {
            let name = pool[index]
            pool.remove(at: index)
            
            return name
            
        } else {
            overflow += 1
            
            return "Georg \(overflow)"
        }
    }
    
}

extension Array {
    
    mutating func popRandomElement() -> Self.Element? {
        if let index = indices.randomElement() {
            let element = self[index]
            self.remove(at: index)
            
            return element
        }
        
        return nil
    }
    
}
