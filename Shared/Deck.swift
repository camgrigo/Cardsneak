//
//  Deck.swift
//  Cardsneak
//
//  Created by Cameron Grigoriadis on 2/8/21.
//

import Foundation

struct Deck {
    
    var cards = [PlayingCard]()
    
    
    func shuffle() -> Deck {
        var cards = self.cards
        (0..<3).forEach { _ in cards.shuffle() }
        
        return self
    }
    
    func deal(to characters: [Player]) {
        var cards = self.cards
        var characters = Carousel(characters)
        
        while !cards.isEmpty {
            let card = cards.popLast()!
            characters.next().cards.append(card)
        }
    }
    
    
    init() {
        PlayingCard.Suit.allCases.forEach { suit in
            PlayingCard.Rank.allCases.forEach { rank in
                cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
    }
    
    init(cards: [PlayingCard]) {
        self.cards = cards
    }
    
}
