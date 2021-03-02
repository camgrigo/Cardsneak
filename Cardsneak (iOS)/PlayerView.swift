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
    
    @Namespace var namespace
    
    @ObservedObject var userPlayer: UserPlayer
    
    @ObservedObject var gameModel: GameModel
    
    @State private var selectedCards = CardStack()
    
    let submitCards: ([PlayingCard]) -> Void
    
    
    var body: some View {
        VStack {
            if userPlayer.state == .selectingCards {
                HStack {
                    CardList(stack: selectedCards, namespace: namespace) {
                        userPlayer.cards.push(selectedCards.pop(id: $0)!)
                    }
                    Button {
                        precondition(Set(selectedCards).isDisjoint(with: userPlayer.cards))
                        submitCards(selectedCards.empty())
                    } label: {
                        Image(systemName: "arrow.up.circle.fill").font(.largeTitle)
                            .foregroundColor(.blue)
                    }
                    .disabled(selectedCards.isEmpty)
                }
                .background(Color(.secondarySystemBackground))
                .scaleEffect()
            }
            CardList(stack: userPlayer.cards, namespace: namespace) {
                guard userPlayer.state == .selectingCards &&
                      selectedCards.count < PlayingCard.suitCount else { return }
                
                selectedCards.push(userPlayer.cards.pop(id: $0)!)
            }
            .background(Color(.tertiarySystemBackground))
            HStack {
                if userPlayer.canChallenge {
                    RoundedButton("Challenge", action: challenge)
                }
            }
            .padding()
            .background(Color(.tertiarySystemBackground))
        }
        .padding(.vertical)
    }
    
    private func challenge() {
        _ = gameModel.receiveChallenge(playerId: userPlayer.id)
    }
    
}
