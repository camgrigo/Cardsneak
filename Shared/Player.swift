//
//  Player.swift
//  Cardsneak
//
//  Created by Cameron Grigoriadis on 2/8/21.
//

import Foundation

class Player: Identifiable {
    let name: String
    let id: Int
    let isNPC: Bool
    
    init(name: String, id: Int, isNPC: Bool = true) {
        self.name = name
        self.id = id
        self.isNPC = isNPC
    }
    
    let caution = (0...8).randomElement()!
    
    var cards = [PlayingCard]()
    var cardList: String {
        cards.enumerated()
            .map { "\($0.offset) | \($0.element.rank) \($0.element.suit)" }
            .joined(separator: "\n")
    }
    
    func discardCards(of rank: PlayingCard.Rank) -> [PlayingCard] {
        var discard = cards.filter { $0.rank == rank }
        
        if discard.isEmpty {
            discard.append(
                contentsOf: (0..<(1...2).randomElement()!)
                    .map { _ in cards.popRandomElement() }
                    .compactMap { $0 }
            )
        }
        
        // If not cautious, add an extra card
        if let card = cards.popRandomElement(),
           caution < 5 && discard.count < 3 {
            discard.append(card)
        }
        
        return discard
    }
    
    func shouldChallenge(player: (playerId: Int, cardCount: Int), rank: PlayingCard.Rank) -> Bool {
        // Opinion of player (Player did/did not challenge him before)
        // Threatened by player (Card count)
        // High card count
        // Good/Bad expectations for next turn (I have all the aces/I don't have any aces)
        let confidenceLevel = (cardCountConfidenceScore() + 5
//            nextTurnProjection(nextRank: <#T##PlayingCard.Rank#>)
        ) / 2
        
        return confidenceLevel >= caution
    }
    
    private func cardCountConfidenceScore() -> Int {
        Int((max(0, 20 - cards.count) / 20) * 10)
    }
    
    private func nextTurnProjection(nextRank: PlayingCard.Rank) -> Int {
        let matches = cards.filter { $0.rank == nextRank }
        
        return Int((matches.count / 4) * 10)
    }
    
}

extension Player: Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }
}
