//
//  Player.swift
//  Cardsneak
//
//  Created by Cameron Grigoriadis on 2/8/21.
//

import Foundation

protocol Player: Identifiable {
    var name: String { get }
    var id: Int { get }
    var cards: [PlayingCard] { get set }
    
    
    func getPlay(rank: PlayingCard.Rank, handler: ([PlayingCard]) -> Void)
    
    func shouldChallenge(player: (playerId: Int, cardCount: Int), rank: PlayingCard.Rank, handler: (Bool) -> Void)
}

class AIPlayer: Player {
    let name: String
    let id: Int
    
    private let caution = (0...8).randomElement()!
    
    var cards = [PlayingCard]()
    //    var cardList: String {
    //        cards.enumerated()
    //            .map { "\($0.offset) | \($0.element.rank) \($0.element.suit)" }
    //            .joined(separator: "\n")
    //    }
    
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
    
    
    func getPlay(rank: PlayingCard.Rank, handler: ([PlayingCard]) -> Void) {
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
        
        handler(discard)
    }
    
    func shouldChallenge(player: (playerId: Int, cardCount: Int), rank: PlayingCard.Rank, handler: (Bool) -> Void) {
        // Opinion of player (Player did/did not challenge him before)
        // Threatened by player (Card count)
        // High card count
        // Good/Bad expectations for next turn (I have all the aces/I don't have any aces)
        let confidenceLevel = (cardCountConfidenceScore() + 5
                               //            nextTurnProjection(nextRank: <#T##PlayingCard.Rank#>)
        ) / 2
        
        handler(confidenceLevel >= caution)
    }
    
    private func cardCountConfidenceScore() -> Int {
        Int((max(0, 20 - cards.count) / 20) * 10)
    }
    
    private func nextTurnProjection(nextRank: PlayingCard.Rank) -> Int {
        let matches = cards.filter { $0.rank == nextRank }
        
        return Int((matches.count / 4) * 10)
    }
    
}

class UserControlledPlayer: Player {
    
    enum State {
        case idle, pickingCards, decidingChallenge
    }
    
    static func == (lhs: UserControlledPlayer, rhs: UserControlledPlayer) -> Bool {
        lhs.id == rhs.id
    }
    
    let name: String
    let id: Int
    
    var cards = [PlayingCard]()
    
    var state = State.idle
    
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
    
    
    func getPlay(rank: PlayingCard.Rank, handler: ([PlayingCard]) -> Void) {
        state = .pickingCards
    }
    
    func shouldChallenge(player: (playerId: Int, cardCount: Int), rank: PlayingCard.Rank, handler: (Bool) -> Void) {
        state = .decidingChallenge
    }
    
}
