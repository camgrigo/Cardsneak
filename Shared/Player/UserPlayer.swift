//
//  UserPlayer.swift
//  Cardsneak
//
//  Created by Cameron Grigoriadis on 2/24/21.
//

import SwiftUI

class UserPlayer: Player, ObservableObject {
    
    let name: String
    
    let id: Int
    
    @Published var cards = CardStack()
    
    @Published var canChallenge = false
    
    enum State {
        case viewing, selectingCards
    }
    
    
    
    @Published var state = State.viewing
    
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
    
    
    func getPlay(rank: PlayingCard.Rank, handler: @escaping ([PlayingCard]) -> Void) {
        print("User selecting cards…")
        withAnimation {
            state = .selectingCards
        }
    }
    
    func shouldChallenge(player: (playerId: Int, cardCount: Int), rank: PlayingCard.Rank, handler: @escaping (Bool) -> Void) {
        print("User may challenge…")
        withAnimation {
            canChallenge = true
        }
    }
    
}
