//
//  Player.swift
//  Cardsneak
//
//  Created by Cameron Grigoriadis on 2/8/21.
//

import Foundation

struct Player {
    let name: String
    let id: Int
    var cards = [PlayingCard]()
}

protocol PlayerController {
    
    var player: Player { get set }
    
    var name: String { get }
    var id: Int { get }
    var cards: [PlayingCard] { get set }
    
    
    mutating func accept(_ cards: PlayingCard...)
    mutating func accept(_ cards: [PlayingCard])
    
    func getPlay(rank: PlayingCard.Rank, handler: @escaping ([PlayingCard]) -> Void)
    func shouldChallenge(player: (playerId: Int, cardCount: Int), rank: PlayingCard.Rank, handler: @escaping (Bool) -> Void)

}

extension PlayerController {
    
    mutating func accept(_ cards: [PlayingCard]) {
        player.cards.append(contentsOf: cards)
    }
    
    mutating func accept(_ cards: PlayingCard...) {
        player.cards.append(contentsOf: cards)
    }
    
}

class AIPlayerController: PlayerController {
    let name: String
    
    let id: Int
    
    var cards = [PlayingCard]()
    
    var player: Player
    
    private let caution = (0...8).randomElement()!
    
    init(player: Player) {
        self.player = player
    }
    
    
    func getPlay(rank: PlayingCard.Rank, handler: @escaping ([PlayingCard]) -> Void) {
        var discard = player.cards.filter { $0.rank == rank }
        
        if discard.isEmpty {
            discard.append(
                contentsOf: (0..<(1...2).randomElement()!)
                    .map { _ in player.cards.popRandomElement() }
                    .compactMap { $0 }
            )
        }
        
        // If not cautious, add an extra card
        if let card = player.cards.popRandomElement(),
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
        Int((max(0, 20 - player.cards.count) / 20) * 10)
    }
    
    private func nextTurnProjection(nextRank: PlayingCard.Rank) -> Int {
        let matches = player.cards.filter { $0.rank == nextRank }
        
        return Int((matches.count / 4) * 10)
    }
    
}

class UserPlayerController: PlayerController, ObservableObject {
    let name: String
    
    let id: Int
    
    var cards = [PlayingCard]()
    
    
    enum State {
        case viewing, selectingCards, decidingChallenge
    }
    
    
    var player: Player
    
    @Published var state = State.viewing
    
    
    init(player: Player) {
        self.player = player
    }
    
    
    func getPlay(rank: PlayingCard.Rank, handler: @escaping ([PlayingCard]) -> Void) {
        state = .selectingCards
    }
    
    func shouldChallenge(player: (playerId: Int, cardCount: Int), rank: PlayingCard.Rank, handler: @escaping (Bool) -> Void) {
        state = .decidingChallenge
    }
    
}
