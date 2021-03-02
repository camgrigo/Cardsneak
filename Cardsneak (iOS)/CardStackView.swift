//
//  CardStackView.swift
//  Cardsneak (iOS)
//
//  Created by Cameron Grigoriadis on 2/15/21.
//

import SwiftUI

struct CardStackView: View {
    
    var cards: CardStack
    
    var showsCount: Bool
    
    var namespace: Namespace.ID
    
    
    init(cards: CardStack, showsCount: Bool = false, namespace: Namespace.ID) {
        self.cards = cards
        self.showsCount = showsCount
        self.namespace = namespace
    }
    
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(cards) { card in
                    PlayingCardView(playingCard: card, isFaceDown: false)
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
