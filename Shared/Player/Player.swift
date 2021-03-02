//
//  Player.swift
//  Cardsneak
//
//  Created by Cameron Grigoriadis on 2/8/21.
//

import Foundation

protocol Player {
    
    var name: String { get }
    var id: Int { get }
    var cards: CardStack { get set }
    
    
    mutating func accept(_ cards: PlayingCard...)
    mutating func accept(_ cards: [PlayingCard])
    
    func getPlay(rank: PlayingCard.Rank, handler: @escaping ([PlayingCard]) -> Void)
    func shouldChallenge(player: (playerId: Int, cardCount: Int), rank: PlayingCard.Rank, handler: @escaping (Bool) -> Void)

}

extension Player {
    
    mutating func accept(_ cards: [PlayingCard]) {
        self.cards.push(cards)
    }
    
    mutating func accept(_ cards: PlayingCard...) {
        self.cards.push(cards)
    }
    
}
