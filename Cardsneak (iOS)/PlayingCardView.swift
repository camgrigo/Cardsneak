//
//  PlayingCardView.swift
//  Cardsneak (iOS)
//
//  Created by Cameron Grigoriadis on 2/14/21.
//

import SwiftUI

struct PlayingCardView: View {
    
    var playingCard: PlayingCard
    
    private var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [Color(.secondarySystemBackground), Color(.tertiarySystemBackground)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(gradient)
            .aspectRatio(0.7, contentMode: .fit)
            .frame(width: 200)
            .shadow(radius: 2)
    }
}

struct PlayingCardView_Previews: PreviewProvider {
    static var previews: some View {
        PlayingCardView(playingCard: PlayingCard(suit: .diamond, rank: .nine))
    }
}
