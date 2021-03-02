//
//  MainGameView.swift
//  Cardsneak
//
//  Created by Cameron Grigoriadis on 2/13/21.
//

import SwiftUI

struct PlayerHUD: View {
    
    let players: [Player]
    
    let currentPlayerId: Int
    
    var body: some View {
        LazyVGrid(columns: [GridItem(), GridItem()]) {
            ForEach(players, id: \.id) { player in
                HStack {
                    Text(player.name)
                    Spacer()
                    Text("\(player.cards.count)")
                        .font(.system(.body, design: .rounded).bold())
                }
                .foregroundColor(player.id == currentPlayerId ? .white : .primary)
                .padding()
                .background((player.id == currentPlayerId ? .blue : Color(.secondarySystemBackground)).cornerRadius(10))
            }
        }
        .padding()
    }
    
}

struct MainGameView: View {
    
    @Binding var isPresented: Bool
    
    @EnvironmentObject var gameModel: GameModel
    
    
    var body: some View {
        NavigationView {
            ZStack {
                //                Color(#colorLiteral(red: 0, green: 1, blue: 0.7009260655, alpha: 1))
                //                    .edgesIgnoringSafeArea(.all)
                VStack {
                    PlayerHUD(players: gameModel.players, currentPlayerId: gameModel.players[gameModel.turnCarousel.currentElement].id)
                    
                    Text("Rank \(gameModel.rankCarousel.currentElement.description)").font(.title)
                    
                    Text("\(gameModel.stack.count)")
                        .font(.system(.largeTitle, design: .rounded).bold())
                        .padding()
                        .background(Color(.secondarySystemBackground).cornerRadius(20))
                    
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
