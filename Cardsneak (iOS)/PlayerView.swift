//
//  PlayerView.swift
//  Cardsneak (iOS)
//
//  Created by Cameron Grigoriadis on 2/14/21.
//

import SwiftUI

struct PlayerView: View {
    
    var player: Player
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                Text(player.name)
                    .padding()
                    .background(Color(.secondarySystemBackground).cornerRadius(15))
                    .padding()
                ForEach(player.cards) {
                    PlayingCardView(playingCard: $0)
                }
            }
        }
        .padding(.vertical)
    }
    
}

//struct PlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerView()
//    }
//}
