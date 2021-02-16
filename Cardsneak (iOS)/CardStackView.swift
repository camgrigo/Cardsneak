//
//  CardStackView.swift
//  Cardsneak (iOS)
//
//  Created by Cameron Grigoriadis on 2/15/21.
//

import SwiftUI

struct CardStackView: View {
    
    var cards: [PlayingCard]
    
    var showsCount: Bool
    
    init(cards: [PlayingCard], showsCount: Bool = false) {
        self.cards = cards
        self.showsCount = showsCount
    }
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(cards) {
                    PlayingCardView(playingCard: $0, isFaceDown: true)
                        .offset(y: CGFloat((cards.firstIndex(of: $0) ?? 0) * 1))
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

//struct CardStackView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardStackView()
//    }
//}
