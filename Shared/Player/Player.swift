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
    
    func getPlay(rank: PlayingCard.Rank, handler: @escaping ([PlayingCard]) -> Void)
    func shouldChallenge(player: (playerId: Int, cardCount: Int), rank: PlayingCard.Rank, handler: @escaping (Bool) -> Void)

}
