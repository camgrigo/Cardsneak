//
//  CardStackView.swift
//  Cardsneak (iOS)
//
//  Created by Cameron Grigoriadis on 2/15/21.
//

import SwiftUI

struct CardStackView: View {
    
    var cards: [PlayingCard]
    
    var body: some View {
        ZStack {
            ForEach(cards) {
                PlayingCardView(playingCard: $0)
                    .offset(y: CGFloat((cards.firstIndex(of: $0) ?? 0) * 1))
            }
        }
        .shadow(radius: 2)
    }
    
}

//struct CardStackView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardStackView()
//    }
//}
