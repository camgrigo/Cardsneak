//
//  GameModel.swift
//  Cardsneak
//
//  Created by Cameron Grigoriadis on 2/8/21.
//

import Foundation

class GameModel: ObservableObject {
    
    let titleCard = """
    
     = = = = = = = = = = = = = = = = = =
    = = = ♦️ ♠️   CARDSNEAK   ♣️ ♥️ = = =
     = = = = = = = = = = = = = = = = = =
    
    """
    
    let nameGenerator = NameGenerator()
    
    @Published var mainPlayer: UserControlledPlayer?
    var playerCarousel = Carousel<Player>()
    var rankCarousel = Carousel(PlayingCard.Rank.allCases)
    var turns = [Turn]()
    var stack: [PlayingCard] {
        turns.reduce([]) {
            var a = $0
            a.append(contentsOf: $1.cards)
            return a
        }
    }
    
    @Published var isInProgress = false
    
    
    func startGame() {
        isInProgress = true
        
        //        print("\nWelcome, \(player.name). This is Cardsneak.")
        
        playerCarousel = Carousel([
            mainPlayer!,
            AIPlayer(name: nameGenerator.generate(), id: 1),
            AIPlayer(name: nameGenerator.generate(), id: 2),
            AIPlayer(name: nameGenerator.generate(), id: 3),
            AIPlayer(name: nameGenerator.generate(), id: 4)
        ])
        
        
        func deal<T: Player>(to characters: [T]) {
            var cards = Deck().shuffled().cards
            var characters = Carousel(characters)
            
            while !cards.isEmpty {
                let card = cards.popLast()!
                characters.next().cards.append(card)
            }
        }
        
        deal(to: playerCarousel.contents)
        
        playerCarousel.spin()
        
        requestPlay(player: playerCarousel.next(), rank: rankCarousel.next())
    }
    
    func requestPlay<T: Player>(player: T, rank: PlayingCard.Rank) {
        player.getPlay(rank: rank) { cards in
            receivePlay(player: player, rank: rank, cards: cards)
        }
    }
    
    func receivePlay<T: Player>(player: T, rank: PlayingCard.Rank, cards: [PlayingCard]) {
        let turn = Turn(player: player, rank: rank, cards: cards)
        turns.append(turn)
        //        print(turn)
        //        print("Challenge or no challenge?")
        
        
        var challengers = playerCarousel.contents
            .filter { $0.id != player.id && $0.id != mainPlayer?.id }
            .filter { _ in [false, false, false, false, true].randomElement()! }
        
        //        if player != mainPlayer {
        //            needsInput = .challenge
        ////            let line = readLine() ?? ""
        //
        ////            if !line.isEmpty {
        ////                challengers.append(mainPlayer!)
        ////            }
        //        }
        //
        //        challengers.shuffle()
        //
        //        if let firstChallenger = challengers.first {
        //            print("\(challengers.count) \(challengers.count == 1 ? "challenger" : "challengers")!")
        //            print("\n\n\"LIES!!!\"\n—\(firstChallenger.name)\n\n")
        //            let lastTurn = turns.last!
        //
        //            let recipient: Player
        //
        //            if lastTurn.isCheat {
        //                print("Challenger wins!")
        //                recipient = lastTurn.player
        //
        //            } else {
        //                print("Challenger loses!")
        //                recipient = firstChallenger
        //            }
        //
        //            print("\n\(recipient.name) gets all the cards in the stack!!!")
        //            print("\(stack.count) \(stack.count == 1 ? "card" : "cards")")
        //
        //            let index = playerCarousel.contents.firstIndex { $0.id == recipient.id }!
        //            playerCarousel.contents[index].cards.append(contentsOf: turns.reduce([]) { $0 + $1.cards })
        //            turns.removeAll()
        //        } else {
        //            print("No challengers. You're safe, \(player.name).")
        //        }
        //
        //
        //        let allHaveCards = playerCarousel.contents.allSatisfy { !$0.cards.isEmpty }
        //
        //        if allHaveCards {
        //                requestPlay(player: playerCarousel.next(), rank: rankCarousel.next())
        //
        //        } else {
        //            gameOver()
        //        }
    }
    
    func endGame() {
        isInProgress = false
    }
    
    
    func gameOver() {
        isInProgress = false
        print("\n\nThanks for playing!\n")
        startGame(player: getPlayer(prompt: "Play again? Enter your name:"))
    }
}
