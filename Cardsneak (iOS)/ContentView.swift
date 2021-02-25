//
//  ContentView.swift
//  Cardsneak (iOS)
//
//  Created by Cameron Grigoriadis on 2/9/21.
//

import SwiftUI

struct TitleCard: View {
    
    var body: some View {
        VStack {
            HStack {
                Text("♠️ ♦️")
                    .font(.footnote)
                LinearGradient(gradient: Gradient(stops: [
                    Gradient.Stop(color: Color.gray, location: 0),
                    Gradient.Stop(color: Color.black, location: 0.6)
                ]), startPoint: .top, endPoint: .bottom)
                .frame(width: 225, height: 50)
                .mask(
                    Text("Cardsneak")
                        .font(Font.system(size: 40, design: .rounded)
                                .weight(.bold))
                )
                .shadow(radius: 2)
                Text("♥️ ♣️")
                    .font(.footnote)
            }.padding()
        }
    }
    
}

struct StylizedTextField: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        TextField(title, text: $text)
            .multilineTextAlignment(.center)
            .padding()
            .foregroundColor(.blue)
            .font(Font.system(.title3, design: .rounded).bold())
            .background(Color(.systemBackground).cornerRadius(20))
    }
}

struct ContentView: View {
    
    @State private var gameModel = GameModel(mainPlayer: UserPlayer(name: String(), id: 0))
    
    @State private var name = String()
    
    @State private var gameViewIsPresented = false
    
    
    var startButton: some View {
        Text("Start")
        .font(Font.system(.title3).weight(.bold))
        .foregroundColor(.white)
        .padding()
        .background(Color.blue.cornerRadius(20))
        .padding()
    }
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0, green: 1, blue: 0.7009260655, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            VStack {
                TitleCard()
                StylizedTextField(title: "Player name", text: $name).padding()
                Button(action: startGame) { startButton }
            }
        }
        .fullScreenCover(isPresented: $gameViewIsPresented) {
            MainGameView(isPresented: $gameViewIsPresented).environmentObject(gameModel)
        }
    }
    
    
    private func startGame() {
        gameModel = GameModel(mainPlayer: UserPlayer(name: name, id: 0))
        
        gameModel.startGame()
        
        gameViewIsPresented = true
    }
    
}
