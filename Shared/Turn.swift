//
//  Turn.swift
//  Cardsneak
//
//  Created by Cameron Grigoriadis on 2/8/21.
//

import Foundation

struct Turn {
    let id: Int
    let playerId: Int
    let rank: PlayingCard.Rank
    let cards: [PlayingCard]
    
    var isCheat: Bool {
        !cards.allSatisfy { $0.rank == rank }
    }
}
