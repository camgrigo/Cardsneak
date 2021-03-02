//
//  MainMenuView.swift
//  Cardsneak (iOS)
//
//  Created by Cameron Grigoriadis on 2/27/21.
//

import SwiftUI

struct MainMenuView: View {
    
    @EnvironmentObject var gameModel: GameModel
    
    @Binding var gameViewIsPresented: Bool

    
    var body: some View {
        VStack {
            TitleCard()
            PlayersEditor(players: $gameModel.players)
            RoundedButton("Start", action: startGame)
        }
    }
    
    
    private func startGame() {
        gameModel.startGame()
        gameViewIsPresented = true
    }
    
}
