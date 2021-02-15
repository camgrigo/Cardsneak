//
//  Deck.swift
//  Cardsneak
//
//  Created by Cameron Grigoriadis on 2/8/21.
//

import Foundation

struct Deck {
    
    var cards = [PlayingCard]()
    
    
    func shuffled() -> Deck {
        var cards = self.cards
        (0..<3).forEach { _ in cards.shuffle() }
        
        return Deck(cards: cards)
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
