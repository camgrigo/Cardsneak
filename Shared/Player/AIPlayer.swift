//
//  AIPlayer.swift
//  Cardsneak
//
//  Created by Cameron Grigoriadis on 2/24/21.
//

import Foundation

class AIPlayer: Player {
    let name: String
    
    let id: Int
    
    var cards = [PlayingCard]()
    
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
    
    
    private let caution = (0...8).randomElement()!
    
    
    func getPlay(rank: PlayingCard.Rank, handler: @escaping ([PlayingCard]) -> Void) {
        var discard = cards.filter { $0.rank == rank }
        
        if discard.isEmpty {
            discard.append(
                contentsOf: (0..<(1...2).randomElement()!)
                    .map { _ in self.cards.popRandomElement() }
                    .compactMap { $0 }
            )
        }
        
        // If not cautious, add an extra card
        if let card = cards.popRandomElement(),
           caution < 5 && discard.count < 3 {
            discard.append(card)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + [2, 3, 4].randomElement()!) {
            handler(discard)
        }
    }
    
    func shouldChallenge(player: (playerId: Int, cardCount: Int), rank: PlayingCard.Rank, handler: @escaping (Bool) -> Void) {
        // Opinion of player (Player did/did not challenge him before)
        // Threatened by player (Card count)
        // High card count
        // Good/Bad expectations for next turn (I have all the aces/I don't have any aces)
        let confidenceLevel = (cardCountConfidenceScore() + 5
                               //            nextTurnProjection(nextRank: <#T##PlayingCard.Rank#>)
        ) / 2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + [0.5, 0.75, 1].randomElement()!) {
            handler(confidenceLevel >= self.caution)
        }
    }
    
    private func cardCountConfidenceScore() -> Int {
        Int((max(0, 20 - cards.count) / 20) * 10)
    }
    
    private func nextTurnProjection(nextRank: PlayingCard.Rank) -> Int {
        Int((cards.filter { $0.rank == nextRank }.count / 4) * 10)
    }
    
}
