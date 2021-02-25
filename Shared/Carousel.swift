//
//  Carousel.swift
//  Service Day
//
//  Created by Cameron Grigoriadis on 3/11/17.
//  Copyright © 2017 Cameron Grigoriadis. All rights reserved.
//

import Foundation

public class Carousel<Element>: Collection, ExpressibleByArrayLiteral {
    
    public typealias Index = Int
    
    // MARK: - Properties
    
    public var contents: [Element]
    
    var currentIndex: Index
    
    public var currentElement: Element {
        return contents[currentIndex]
    }
    
    public var startIndex: Int { contents.startIndex }
    
    public var endIndex: Int { contents.endIndex }
    
    
    
    public subscript(position: Int) -> Slice<Carousel<Element>> {
        return contents[position] as! Slice<Carousel<Element>>
    }
    
    // MARK: - Increment & Decrement
    
    func increment() {
        currentIndex = index(after: currentIndex)
    }
    
    public func index(after i: Int) -> Int {
        let nextIndex = contents.index(after: currentIndex)
        return nextIndex < contents.endIndex ? nextIndex : contents.startIndex
    }
    
    func decrement() {
        currentIndex = index(before: currentIndex)
    }
    
    public func index(before i: Int) -> Int {
        let previousIndex = contents.index(before: currentIndex)
        return previousIndex < contents.endIndex ? previousIndex : contents.index(before: contents.endIndex)
    }
    
    // MARK: - Interaction
    
    public func next() -> Element {
        defer { increment() }
        
        return contents[currentIndex]
    }
    
    public func previous() -> Element {
        defer { decrement() }
        
        return contents[currentIndex]
    }
    
    public func append(_ item: Element) {
        contents.append(item)
    }
    
    public func spin() {
        let spinCount = (0..<contents.count).randomElement()!
        
        guard spinCount >= 1 else { return }
        
        (1...spinCount).forEach { _ in increment() }
    }
    
    
    // MARK: - Initialization
    
    public init(_ items: [Element], advancedBy offset: Int = 0) {
        self.contents = items
        self.currentIndex = items.startIndex
        
        guard offset > 0 else { return }
        
        for _ in 0 ..< offset {
            increment()
        }
    }
    
    /// Creates an instance initialized with the given elements.
    required public convenience init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
    
}

