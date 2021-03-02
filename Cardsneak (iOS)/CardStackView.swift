//
//  CardStackView.swift
//  Cardsneak (iOS)
//
//  Created by Cameron Grigoriadis on 2/15/21.
//

import SwiftUI

struct CardStackView: View {
    
    @Namespace var namespace
    
    var cards: CardStack
    
    var showsCount: Bool
    
    
    init(cards: CardStack, showsCount: Bool = false) {
        self.cards = cards
        self.showsCount = showsCount
    }
    
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(cards) { card in
                    PlayingCardView(playingCard: card, isFaceDown: true)
                        .offset(y: CGFloat((cards.firstIndex(of: card) ?? 0) * 1))
                        .matchedGeometryEffect(id: card.id, in: namespace)
                }
            }
            .shadow(radius: 2)
            
            if showsCount {
                Text("\(cards.count)")
                    .font(Font.system(.title, design: .rounded).weight(.semibold))
                    .foregroundColor(.secondary)
            }
        }
    }
    
}
