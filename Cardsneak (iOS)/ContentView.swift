//
//  ContentView.swift
//  Cardsneak (iOS)
//
//  Created by Cameron Grigoriadis on 2/9/21.
//

import SwiftUI

struct RoundedTextField: View {
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
    
    
    var body: some View {
        MainMenuView(gameViewIsPresented: $gameViewIsPresented)
            .environmentObject(gameModel)
            .fullScreenCover(isPresented: $gameViewIsPresented) {
                MainGameView(isPresented: $gameViewIsPresented)
                    .environmentObject(gameModel)
            }
    }
    
}
