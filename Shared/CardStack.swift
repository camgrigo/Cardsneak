//
//  CardStack.swift
//  Cardsneak
//
//  Created by Cameron Grigoriadis on 2/8/21.
//

import Foundation

class CardStack: RandomAccessCollection {
    
    typealias Index = Int
    
    typealias Element = PlayingCard
    
    
    private var contents = [Element]()
    
    var startIndex: Index { contents.startIndex }
    var endIndex: Index { contents.endIndex }

    
    subscript(position: Int) -> Element {
        get { contents[position] }
    }

    
    func index(after i: Index) -> Index {
        contents.index(after: i)
    }
    
    
    /// Creates a standard 52-card deck.
    /// - Returns: A stack containing 52 cards
    class func standardDeck() -> CardStack {
        let stack = CardStack()
        
        stack.push(
            PlayingCard.Suit.allCases.map { suit in
                PlayingCard.Rank.allCases.map { rank in
                    PlayingCard(suit: suit, rank: rank)
                }
            }
            .flatMap { $0 }
        )
        
        return stack
    }
    
    
    /// Shuffles the stack of cards.
    /// - Returns: A stack of cards
    func shuffle() -> CardStack {
        contents.shuffle()
        
        return self
    }
    
    func deal(to players: inout [Player]) {
        let carousel = Carousel(Array(0..<players.count))
        
        while let card = contents.popLast() {
            players[carousel.next()].accept(card)
        }
    }
    
    
    func push(_ card: PlayingCard) {
        contents.append(card)
    }
    
    func push(_ cards: [PlayingCard]) {
        contents.append(contentsOf: cards)
    }
    
    func pushToBottom(_ card: PlayingCard) {
        contents.insert(card, at: 0)
    }
    
    func pushToBottom(_ cards: [PlayingCard]) {
        contents.insert(contentsOf: cards, at: 0)
    }
    
    
    func pop() -> Element? {
        contents.removeLast()
    }
    
    func popFirst() -> Element? {
        contents.removeFirst()
    }
    
    func popRandomElement() -> Element? {
        contents.popRandomElement()
    }
    
    func pop(id: PlayingCard.ID) -> Element? {
        guard let index = contents.firstIndex(where: { $0.id == id }) else { return nil }
        
        contents.remove(at: index)
        
        return contents[index]
    }
    
    func popAll(where block: (Element) -> Bool) -> [Element] {
        let partition = contents.partition(by: block)
        
        let popArray = Array(contents[partition...])
        contents = Array(contents[..<partition])
        
        return popArray
    }
    
    /// Empties the stack of all contents and returns them as an array.
    /// - Returns: The contents of the stack.
    func empty() -> [PlayingCard] {
        defer { contents.removeAll() }
        
        return contents
    }
    
}
