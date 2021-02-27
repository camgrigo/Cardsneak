//
//  MainGameView.swift
//  Cardsneak
//
//  Created by Cameron Grigoriadis on 2/13/21.
//

import SwiftUI

struct MainGameView: View {
    
    @Binding var isPresented: Bool
    
    @EnvironmentObject var gameModel: GameModel
    
    var topViewPlayers: [Player] {
        gameModel.players.filter { $0.id != gameModel.userPlayer.id }
    }
    
    
    var body: some View {
        NavigationView {
            ZStack {
                //                Color(#colorLiteral(red: 0, green: 1, blue: 0.7009260655, alpha: 1))
                //                    .edgesIgnoringSafeArea(.all)
                VStack {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], alignment: .center, spacing: 10) {
                        ForEach(topViewPlayers, id: \.id) { player in
                            VStack {
                                Text(player.name)
                                    .font(.title3)
                                    .multilineTextAlignment(.center)
                                Text("\(player.cards.count)")
                                    .font(.title)
                                    .bold()
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground).cornerRadius(10))
                            .padding()
                        }
                    }
                    PlayerView(userPlayer: gameModel.players[0] as! UserPlayer, gameModel: gameModel) {
                        gameModel.receivePlay(cards: $0)
                    }
                }
            }
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
