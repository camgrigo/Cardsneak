//
//  PlayerView.swift
//  Cardsneak (iOS)
//
//  Created by Cameron Grigoriadis on 2/14/21.
//

import SwiftUI

struct PlayerView: View {
    
    var player: UserControlledPlayer
    
    @State private var selectedCards = [PlayingCard]()
    
    @Binding var isSelecting: Bool
    
    let submitCards: ([PlayingCard]) -> Void
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(player.cards) { card in
                        if isSelecting {
                            if let index = selectedCards.firstIndex(of: card) {
                                PlayingCardView(playingCard: card)
                                    .onTapGesture {
                                        selectedCards.remove(at: index)
                                    }
                                
                            } else {
                                PlayingCardView(playingCard: card)
                                    .shadow(color: .red, radius: 5)
                                    .onTapGesture {
                                        selectedCards.append(card)
                                    }
                            }
                        } else {
                            PlayingCardView(playingCard: card)
                        }
                    }
                }
            }
            .padding(.vertical)
            
            if isSelecting {
                Button("Done") {
                    submitCards(selectedCards)
                    selectedCards.removeAll()
                }
            }
        }
    }
    
}

struct ChallengePicker: View {
    
    let submit: (Bool) -> Void
    
    var body: some View {
        VStack {
            Text("Challenge?")
            HStack {
                Button("Yes") {
                    submit(true)
                }
                Button("No") {
                    submit(false)
                }
            }
        }
    }
    
}

//struct PlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerView()
//    }
//}
