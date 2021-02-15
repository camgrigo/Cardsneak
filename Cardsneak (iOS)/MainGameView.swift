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
            VStack {
                VStack {
                    HStack {
                        
                            CardStackView(cards: gameModel.playerCarousel.contents[1].cards)
                            Spacer()
                            CardStackView(cards: gameModel.playerCarousel.contents[2].cards)
                    }
                    HStack {
                        Spacer()
                        CardStackView(cards: gameModel.stack)
                        Spacer()
                    }
                    HStack {
                        CardStackView(cards: gameModel.playerCarousel.contents[3].cards)
                        Spacer()
                        CardStackView(cards: gameModel.playerCarousel.contents[4].cards)
                    }
                }
                PlayerView(player: gameModel.mainPlayer!)
            }
            .toolbar {
                ToolbarItem { menuButton }
            }
        }
        .actionSheet(isPresented: $isShowingMenu, content: {
            ActionSheet(title: Text("Menu"), buttons: [
                .destructive(Text("End Game")) {
                    gameModel.endGame()
                },
                .cancel(Text("Close"))
            ])
        })
    }
    
}

struct MainGameView_Previews: PreviewProvider {
    static var previews: some View {
        MainGameView()
    }
}
