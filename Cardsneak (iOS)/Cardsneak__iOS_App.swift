//
//  Cardsneak__iOS_App.swift
//  Cardsneak (iOS)
//
//  Created by Cameron Grigoriadis on 2/9/21.
//

import SwiftUI

@main
struct Cardsneak__iOS_App: App {
    
    @ObservedObject var gameModel = GameModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(gameModel)
            }
        }
    }
    
}
