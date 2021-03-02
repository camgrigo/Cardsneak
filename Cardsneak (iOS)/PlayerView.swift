//
//  PlayerView.swift
//  Cardsneak (iOS)
//
//  Created by Cameron Grigoriadis on 2/14/21.
//

import SwiftUI

struct CardList: View {
    
    let stack: CardStack
    
    var namespace: Namespace.ID
    
    let onSelect: (PlayingCard.ID) -> Void
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(stack) { card in
                    PlayingCardView(playingCard: card)
                        .matchedGeometryEffect(id: card.id, in: namespace)
                        .onTapGesture { onSelect(card.id) }
                }
            }
            .padding()
        }
    }
    
}

struct PlayerView: View {
    
    @ObservedObject var userPlayer: UserPlayer
    
    @ObservedObject var gameModel: GameModel
    
    @State private var selectedCards = CardStack()
    
    var namespace: Namespace.ID
    
    let submitCards: ([PlayingCard]) -> Void
    
    
    private var submitButton: some View {
        Button {
            print("Selected:", selectedCards, "User:", userPlayer.cards)
            precondition(Set(selectedCards).isDisjoint(with: userPlayer.cards))
            submitCards(selectedCards.empty())
        } label: {
            Image(systemName: "arrow.up.circle.fill").font(.largeTitle)
        }
        .padding()
        .disabled(selectedCards.isEmpty)
    }
    
    var body: some View {
        
        VStack {
            if userPlayer.state == .selectingCards {
                VStack {
                    submitButton
                    CardList(stack: selectedCards, namespace: namespace) {
                        print($0)
                        userPlayer.cards.append(selectedCards.pop(id: $0)!)
                    }
                }
                .background(Color.blue.opacity(0.2).cornerRadius(8))
                .padding()
            }
            CardList(stack: userPlayer.cards, namespace: namespace) {
                print($0)
                guard userPlayer.state == .selectingCards &&
                        selectedCards.count < PlayingCard.suitCount else { return }
                
                selectedCards.append(userPlayer.cards.pop(id: $0)!)
            }
            
            HStack {
                
                    RoundedButton("Challenge", action: challenge)
                        .disabled(!userPlayer.canChallenge)
                
            }
            .padding()
            
        }
        .padding(.vertical)
        
    }
    
    private func challenge() {
        _ = gameModel.receiveChallenge(playerId: userPlayer.id)
    }
    
}
