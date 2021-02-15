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
        Text(player.name)
            .padding()
            .background(Color(.secondarySystemBackground).cornerRadius(15))
            .padding()
        HStack {
            ForEach(player.cards) {
                PlayingCardView(playingCard: $0)
            }
        }
    }
    
}

//struct PlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerView()
//    }
//}
