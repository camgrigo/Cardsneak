//
//  PlayingCardView.swift
//  Cardsneak (iOS)
//
//  Created by Cameron Grigoriadis on 2/14/21.
//

import SwiftUI

struct PlayingCardView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    
    var playingCard: PlayingCard
    
    var isFaceDown: Bool
    
    
    init(playingCard: PlayingCard, isFaceDown: Bool = false) {
        self.playingCard = playingCard
        self.isFaceDown = isFaceDown
    }
    
    
    private var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [Color(.secondarySystemBackground), Color(.tertiarySystemBackground)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(gradient)
//            .aspectRatio(0.7, contentMode: .fit)
            .frame(width: 90, height: 130)
            .shadow(radius: 2)
    }
    
    private var face: some View {
        VStack {
            Text("\(playingCard.rank.description)")
                .font(Font.system(size: 50, design: .monospaced))
                .foregroundColor(playingCard.suit.color)
                .padding(.bottom, -10)
            if colorScheme == .dark {
                Text("\(playingCard.suit.description)")
                    .font(Font.system(size: 26))
                    .padding(4)
                    .background(Circle().fill(Color.white))
            } else {
                Text("\(playingCard.suit.description)")
                    .font(Font.system(size: 26))
            }
        }
    }
    
    var body: some View {
        ZStack {
            background
            if !isFaceDown {
                face
            }
        }
    }
    
}

struct PlayingCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
                PlayingCardView(playingCard: PlayingCard(suit: .diamond, rank: .nine))
                    .padding()
                    .background(Color.green)
                    .previewLayout(.sizeThatFits)
                PlayingCardView(playingCard: PlayingCard(suit: .spade, rank: .jack))
                    .padding()
                    .background(Color.green)
                    .previewLayout(.sizeThatFits)
                    .colorScheme(.dark)
        }
    }
    
}
