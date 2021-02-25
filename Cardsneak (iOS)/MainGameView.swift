//
//  MainGameView.swift
//  Cardsneak
//
//  Created by Cameron Grigoriadis on 2/13/21.
//

import SwiftUI

struct MainGameView: View {
    
    @EnvironmentObject var gameModel: GameModel
    
    @State private var isShowingMenu = false
    
    private var menuButton: some View {
        Button("Menu") {
            isShowingMenu = true
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(#colorLiteral(red: 0, green: 1, blue: 0.7009260655, alpha: 1))
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("\("Cameron")'s Turn")
                    VStack {
                        HStack {
                            CardStackView(cards: gameModel.players[1].player.cards)
                            Spacer()
                            CardStackView(cards: gameModel.players[2].player.cards)
                        }
                        HStack {
                            Spacer()
                            CardStackView(cards: gameModel.stack, showsCount: true)
                            Spacer()
                        }
                        HStack {
                            CardStackView(cards: gameModel.players[3].player.cards)
                            Spacer()
                            CardStackView(cards: gameModel.players[4].player.cards)
                        }
                    }
                    PlayerView(userPlayerController: gameModel.mainPlayer!, gameModel: gameModel) {
                        gameModel.receivePlay(cards: $0)
                    }
                }
            }
            .toolbar {
                ToolbarItem { menuButton }
            }
        }
        .actionSheet(isPresented: $isShowingMenu) {
            ActionSheet(title: Text("Menu"), buttons: [
                .destructive(Text("End Game")) {
                    gameModel.endGame()
                },
                .cancel(Text("Close"))
            ])
        }
    }
    
}

struct MainGameView_Previews: PreviewProvider {
    static var previews: some View {
        MainGameView()
    }
}
