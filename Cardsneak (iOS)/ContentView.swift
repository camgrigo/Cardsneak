//
//  ContentView.swift
//  Cardsneak (iOS)
//
//  Created by Cameron Grigoriadis on 2/9/21.
//

import SwiftUI

struct StylizedTextField: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        TextField(title, text: $text)
            .multilineTextAlignment(.center)
            .padding()
            .foregroundColor(.blue)
            .font(Font.system(.title3, design: .rounded).bold())
            .background(Color(.secondarySystemBackground).cornerRadius(20))
    }
}

struct ContentView: View {
    
    @State private var gameModel = GameModel()
    
    @State private var gameViewIsPresented = false
    
    
    var startButton: some View {
        Text("Start")
        .font(Font.system(.title3).weight(.bold))
        .foregroundColor(.white)
            .padding(.horizontal, 15)
        .padding()
        .background(Color.blue.cornerRadius(20))
        .padding()
    }
    
    var body: some View {
        ZStack {
            //            Color(#colorLiteral(red: 0, green: 1, blue: 0.7009260655, alpha: 1))
            //                .edgesIgnoringSafeArea(.all)
            VStack {
                TitleCard()
                PlayersEditor(players: $gameModel.players)
                Button(action: startGame) { startButton }
            }
        }
        .fullScreenCover(isPresented: $gameViewIsPresented) {
            MainGameView(isPresented: $gameViewIsPresented).environmentObject(gameModel)
        }
    }
    
    
    private func startGame() {
        gameModel.startGame()
        gameViewIsPresented = true
    }
    
}
