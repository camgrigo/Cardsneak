//
//  PlayerHUD.swift
//  Cardsneak (iOS)
//
//  Created by Cameron Grigoriadis on 3/1/21.
//

import SwiftUI

struct PlayerHUD: View {
    
    let players: [Player]
    
    let currentPlayerId: Int
    
    private func highlightedRow(player: Player) -> some View {
        VStack {
            Text(player.name)
                .font(.system(.headline, design: .rounded).bold())
            Text("\(player.cards.count)")
                .font(.system(.headline, design: .rounded).weight(.heavy))
        }
        .multilineTextAlignment(.center)
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color.blue.opacity(0.2).cornerRadius(8))
    }
    
    private func row(player: Player) -> some View {
        VStack {
            Text(String(player.name.first ?? Character("")))
                .font(.system(.body, design: .rounded).bold())
            Text("\(player.cards.count)")
                .font(.system(.body, design: .rounded).weight(.heavy))
        }
        .multilineTextAlignment(.center)
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
    
    var body: some View {
        HStack {
            ForEach(players, id: \.id) { player in
                if player.id == currentPlayerId {
                    highlightedRow(player: player)
                    
                } else {
                    row(player: player)
                }
            }
        }
        .padding()
    }
    
}
