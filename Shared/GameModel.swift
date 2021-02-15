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

    @Published var mainPlayer: Player?
    var playerCarousel = Carousel<Player>()
    var rankCarousel = Carousel(PlayingCard.Rank.allCases)
    var turns = [Turn]()
    var stackCount: Int {
        turns.reduce(0) { $0 + $1.cards.count }
    }
    
    @Published var isInProgress = false
    
    
    func load() {
        print(titleCard)
        startGame(player: getPlayer())
    }
    
    func getPlayer(prompt: String = "Enter your name to begin:") -> Player {
        print(prompt)
        let name = { () -> String in
            let nameLine = readLine()
            if let nameLine = nameLine, !nameLine.isEmpty {
                return nameLine
            } else {
                return nameGenerator.generate()
            }
        }()
        
        return Player(name: name, id: 0, isNPC: false)
    }

    func startGame(player: Player) {
        isInProgress = true
        
        print("\nWelcome, \(player.name). This is Cardsneak.")
        
        mainPlayer = player
        
        playerCarousel = Carousel([
            mainPlayer!,
            Player(name: nameGenerator.generate(), id: 1),
            Player(name: nameGenerator.generate(), id: 2),
            Player(name: nameGenerator.generate(), id: 3),
            Player(name: nameGenerator.generate(), id: 4)
        ])
        
        Deck()
            .shuffle()
            .deal(to: playerCarousel.contents)
        
        playerCarousel.spin()
        
//        beginTurn()
    }

    func beginTurn() {
        guard let mainPlayer = mainPlayer else { return }
        let player = playerCarousel.next()
        let rank = rankCarousel.next()
        
        print("The stack has \(stackCount) \(stackCount == 1 ? "card" : "cards")")
        print("Player:", player.name, "\nRank:", rank)
        
        var discardedCards = [PlayingCard]()
        
        if player != mainPlayer {
            let cardCount = [
                Array(repeating: 1, count: 8),
                Array(repeating: 2, count: 5),
                Array(repeating: 3, count: 3),
                Array(repeating: 4, count: 1)
            ]
            .joined()
            .randomElement()!
            
            discardedCards.append(
                contentsOf: (0..<cardCount)
                    .map { _ in
                        if  let index = player.cards.indices.randomElement() {
                            let card = player.cards[index]
                            player.cards.remove(at: index)
                            
                            return card
                        }
                        
                        return nil
                    }
                    .compactMap { $0 }
            )
            
        } else {
            print(mainPlayer.cards.enumerated().map { "\($0.offset) | \($0.element.rank) of \($0.element.suit)" })
            print("Select 1-4 cards to discard by entering their index, one at a time.\nPress ENTER when done.")
            
            var isReading = true
            
            while isReading {
                let line = readLine()
                
                if let line = line,
                   let index = Int(line)
                {
                    if player.cards.indices.contains(index) {
                        discardedCards.append(player.cards[index])
                        isReading = discardedCards.count < PlayingCard.Suit.allCases.count
                        
                        if discardedCards.count == PlayingCard.Suit.allCases.count {
                            print("🤔 Bold move…")
                        }
                        
                    } else {
                        print("Make sure to pick a valid index. (0, 1, 2, 3, etc.)")
                    }

                } else {
                    isReading = discardedCards.isEmpty
                    if discardedCards.isEmpty {
                        print("Make sure to pick at least 1 card! ☝️")
                    }
                }
            }
        }
        
        let turn = Turn(player: player, rank: rank, cards: discardedCards)
        turns.append(turn)
        print(turn)
        print("Challenge or no challenge?")
        
        
        var challengers = playerCarousel.contents
            .filter { $0.id != player.id && $0.isNPC }
            .filter { _ in [false, false, false, false, true].randomElement()! }
        
        if player != mainPlayer {
            let line = readLine() ?? ""
            
            if !line.isEmpty {
                challengers.append(mainPlayer)
            }
        }
        
        challengers.shuffle()
        
        if let firstChallenger = challengers.first {
            print("\(challengers.count) \(challengers.count == 1 ? "challenger" : "challengers")!")
            print("\n\n\"LIES!!!\"\n—\(firstChallenger.name)\n\n")
            let lastTurn = turns.last!
            
            let recipient: Player
            
            if lastTurn.isCheat {
                print("Challenger wins!")
                recipient = lastTurn.player

            } else {
                print("Challenger loses!")
                recipient = firstChallenger
            }
            
            print("\n\(recipient.name) gets all the cards in the stack!!!")
            print("\(stackCount) \(stackCount == 1 ? "card" : "cards")")
            
            let index = playerCarousel.contents.firstIndex { $0.id == recipient.id }!
            playerCarousel.contents[index].cards.append(contentsOf: turns.reduce([]) { $0 + $1.cards })
            turns.removeAll()
        } else {
            print("No challengers. You're safe, \(player.name).")
        }
        
        
        let allHaveCards = playerCarousel.contents.allSatisfy { !$0.cards.isEmpty }
        
        if allHaveCards {
            beginTurn()
            
        } else {
            gameOver()
        }
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
