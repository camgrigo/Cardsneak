//
//  CardStack.swift
//  Cardsneak
//
//  Created by Cameron Grigoriadis on 2/8/21.
//

import Foundation

typealias CardStack = Array<PlayingCard>

//struct CardStack: RandomAccessCollection {
    
//    typealias Index = Int
    
//    typealias Element = PlayingCard
    
    
//    private var contents = [Element]()
    
//    var startIndex: Index { contents.startIndex }
//    var endIndex: Index { contents.endIndex }

    
//    subscript(position: Int) -> Element {
//        get { contents[position] }
//    }

    
//    func index(after i: Index) -> Index {
//        contents.index(after: i)
//    }
    
    
    /// Shuffles the stack of cards.
    /// - Returns: A stack of cards
//    mutating func shuffle() -> CardStack {
//        contents.shuffle()
//
//        return self
//    }

    
//
//    mutating func pop() -> Element? {
//        contents.removeLast()
//    }
//
//    mutating func popFirst() -> Element? {
//        contents.removeFirst()
//    }
    
//    mutating func popRandomElement() -> Element? {
//        contents.popRandomElement()
//    }
    
    
//}

extension Array where Element == PlayingCard {
    
    /// Creates a standard 52-card deck.
    /// - Returns: A stack containing 52 cards
    static func standardDeck() -> CardStack {
        PlayingCard.Suit.allCases.map { suit in
            PlayingCard.Rank.allCases.map { rank in
                PlayingCard(suit: suit, rank: rank)
            }
        }
        .flatMap { $0 }
    }
    
    
    mutating func pushToBottom(_ card: PlayingCard) {
        insert(card, at: startIndex)
    }
    
    mutating func pushToBottom(_ cards: [PlayingCard]) {
        insert(contentsOf: cards, at: startIndex)
    }
    
    
    func deal(to players: inout [Player]) {
        var copy = self
        let carousel = Carousel<Int>(Array<Int>(0..<players.count))
        
        while let card = copy.popLast() {
            players[carousel.next()].cards.append(card)
        }
    }
    
    
    
    mutating func pop(id: PlayingCard.ID) -> Element? {
        if let index = firstIndex(where: { $0.id == id }) {
            remove(at: index)
            return self[index]
        }
        
        return nil
    }
    
    mutating func popAll(where block: (Element) -> Bool) -> [Element] {
        let partition = partition(by: block)
        let popArray = Array(self[partition...])
        self = Array(self[..<partition])
        
        return popArray
    }
    
    /// Empties the stack of all contents and returns them as an array.
    /// - Returns: The contents of the stack.
    mutating func empty() -> [PlayingCard] {
        defer { removeAll() }
        return self
    }
    
}
