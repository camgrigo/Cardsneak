//
//  MainGameView.swift
//  Cardsneak
//
//  Created by Cameron Grigoriadis on 2/13/21.
//

import SwiftUI

struct MainGameView: View {
    
    @Namespace var cardAnimationNamespace
    
    @Binding var isPresented: Bool
    
    @EnvironmentObject var gameModel: GameModel
    
    
    var body: some View {
        
        NavigationView {
            VStack {
                PlayerHUD(players: gameModel.players, currentPlayerId: gameModel.players[gameModel.turnCarousel.currentElement].id)
                CardStackView(cards: gameModel.stack, showsCount: true, namespace: cardAnimationNamespace)
                PlayerView(userPlayer: gameModel.players[0] as! UserPlayer, gameModel: gameModel, namespace: cardAnimationNamespace) {
                    gameModel.receivePlay(cards: $0)
                }
            }
            .navigationTitle(
                gameModel.state == .loading ?
                    "Loading" : "Rank: \(gameModel.rankCarousel.currentElement.description)"
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Menu {
                        Button("End Game") {
                            gameModel.endGame()
                            isPresented = false
                        }
                    } label: {
                        Image(systemName: "tray.full")
                            .imageScale(.large)
                    }
                }
            }
        }
        
    }
    
}

struct MainGameView_Previews: PreviewProvider {
    
    @State private static var isPresented = true
    
    static var previews: some View {
        MainGameView(isPresented: $isPresented)
    }
}
