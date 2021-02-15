//
//  Turn.swift
//  Cardsneak
//
//  Created by Cameron Grigoriadis on 2/8/21.
//

import Foundation

struct Turn: CustomStringConvertible {
    let player: Player
    let rank: PlayingCard.Rank
    let cards: [PlayingCard]
    
    var isCheat: Bool {
        !cards.allSatisfy { $0.rank == rank }
    }
    
    var description: String {
        "\(player.name) put down \(cards.count) \(cards.count == 1 ? "card" : "cards") of supposed rank \(rank)."
    }
}
