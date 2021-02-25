//
//  UserPlayer.swift
//  Cardsneak
//
//  Created by Cameron Grigoriadis on 2/24/21.
//

import Foundation

class UserPlayerController: Player, ObservableObject {
    
    let name: String
    
    let id: Int
    
    var cards = [PlayingCard]()
    
    
    enum State {
        case viewing, selectingCards, decidingChallenge
    }
    
    
    
    @Published var state = State.viewing
    
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
    
    
    func getPlay(rank: PlayingCard.Rank, handler: @escaping ([PlayingCard]) -> Void) {
        state = .selectingCards
    }
    
    func shouldChallenge(player: (playerId: Int, cardCount: Int), rank: PlayingCard.Rank, handler: @escaping (Bool) -> Void) {
        state = .decidingChallenge
    }
    
}
