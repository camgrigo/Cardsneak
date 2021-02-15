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
    
    var body: some View {
        NavigationView {
            LazyVGrid(columns: [GridItem(), GridItem()], content: {
                ForEach(gameModel.playerCarousel.contents) {
                    PlayerView(player: $0)
                }
            })
                .toolbar {
                    ToolbarItem {
                        Button("Menu") {
                            isShowingMenu = true
                        }
                    }
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
