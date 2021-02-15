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
        Text("Hello, World!")
            .toolbar {
                Button(action: {
                    isShowingMenu = true
                }, label: {
                    Text("Menu")
                })
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
    
}

struct MainGameView_Previews: PreviewProvider {
    static var previews: some View {
        MainGameView()
    }
}
