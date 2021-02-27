//
//  PlayerView.swift
//  Cardsneak (iOS)
//
//  Created by Cameron Grigoriadis on 2/14/21.
//

import SwiftUI

struct PlayerView: View {
    
    @ObservedObject var userPlayer: UserPlayer
    
    @ObservedObject var gameModel: GameModel
    
    @State private var selectedCards = [PlayingCard]()
    
    let submitCards: ([PlayingCard]) -> Void
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(selectedCards) { card in
                        PlayingCardView(playingCard: card)
                            .padding(4)
                            .background(Color.blue.cornerRadius(16))
                            .onTapGesture {
                                let index = selectedCards.firstIndex(of: card)!
                                selectedCards.remove(at: index)
                            }
                    }
                }
                .padding()
            }
            
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(userPlayer.cards.filter { !selectedCards.contains($0) }) { card in
                        if userPlayer.state == .selectingCards {
                            PlayingCardView(playingCard: card)
                                .onTapGesture {
                                    if selectedCards.count < PlayingCard.Suit.allCases.count {
                                        selectedCards.append(card)
                                    }
                                }
                            
                        } else {
                            PlayingCardView(playingCard: card)
                        }
                    }
                }
                .padding()
            }
            
            if userPlayer.state == .selectingCards {
                Button("Done") {
                    submitCards(selectedCards)
                    selectedCards.removeAll()
                }
            }
        }
        .padding(.vertical)
    }
    
}
