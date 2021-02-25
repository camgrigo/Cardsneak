//
//  PlayerView.swift
//  Cardsneak (iOS)
//
//  Created by Cameron Grigoriadis on 2/14/21.
//

import SwiftUI

struct PlayerView: View {
    
    @ObservedObject var userPlayerController: UserPlayerController
    
    @ObservedObject var gameModel: GameModel
    
    @State private var selectedCards = [PlayingCard]()
    
    let submitCards: ([PlayingCard]) -> Void
    
    var body: some View {
        if userPlayerController.state == .decidingChallenge {
            ChallengePicker { shouldChallenge in
                _ = gameModel.receiveChallenge(playerId: userPlayerController.id)
            }
            
        } else {
                VStack {
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(userPlayerController.cards) { card in
                                if userPlayerController.state == .selectingCards {
                                    
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
                    
                    if userPlayerController.state == .selectingCards {
                        Button("Done") {
                            submitCards(selectedCards)
                            selectedCards.removeAll()
                        }
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
