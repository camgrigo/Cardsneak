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
    
    var mainPlayer: UserPlayerController?
    
    @Published var playerCarousel = Carousel<Int>()
    var players = [PlayerController]()
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
    
    var allHaveCards: Bool {
        players.allSatisfy { !$0.player.cards.isEmpty }
    }
    
    
    enum GameState {
        case deal, discard, challenge, collection
    }
    
    @Published var state = GameState.deal
    
    
    func configurePlayers() {
        players = [
            mainPlayer!,
            AIPlayerController(player: Player(name: nameGenerator.generate(), id: 1)),
            AIPlayerController(player: Player(name: nameGenerator.generate(), id: 2)),
            AIPlayerController(player: Player(name: nameGenerator.generate(), id: 3)),
            AIPlayerController(player: Player(name: nameGenerator.generate(), id: 4))
        ]
        playerCarousel = Carousel(players.map { $0.player.id })
        
        print(players.map { "\($0.player.id): \($0.player.name)" })
    }
    
    func dealCards() {
        print("Dealing cards…")
        
        var cards = Deck().shuffled().cards
        
        while !cards.isEmpty {
            let card = cards.popLast()!
            
            if let index = players.firstIndex(where: { $0.player.id == playerCarousel.next() }) {
                players[index].accept(card)
            }
        }
        
        print(players.map { "Player \($0.player.id) Card Count: \($0.player.cards.count)" })
    }
    
    func startGame() {
        print("Game starting")
        isInProgress = true
        
        configurePlayers()
        dealCards()
        
        playerCarousel.spin()
        print("Starting player:", playerCarousel.currentElement)
        
        startTurn()
    }
    
    func startTurn() {
        players
            .first { $0.player.id == playerCarousel.next() }?
            .getPlay(rank: rankCarousel.next(), handler: receivePlay)
    }
    
    func receivePlay(cards: [PlayingCard]) {
        state = .discard
        print("Discarding…")
        
        let turn = Turn(
            id: (turns.last?.id ?? 0 + 1),
            playerId: playerCarousel.currentElement,
            rank: rankCarousel.currentElement,
            cards: cards
        )
        turns.append(turn)
        
        let currentPlayerId = playerCarousel.currentElement
        let currentPlayer = players.first { $0.player.id == currentPlayerId }!
        
        players
            .filter { $0.player.id != currentPlayerId }
            .forEach { playerController in
                playerController.shouldChallenge(player: (playerId: currentPlayerId, cardCount: currentPlayer.player.cards.count), rank: rankCarousel.currentElement) { isChallenging in
                    if isChallenging, let lastTurn = self.turns.last, lastTurn.id == turn.id {
                        _ = self.receiveChallenge(playerId: playerController.player.id)
                    }
                }
            }
        
        //                    print("No challengers. You're safe, \(player.name).")
        
        if allHaveCards {
            startTurn()
            
        } else {
            gameOver()
        }
    }
    
    func receiveChallenge(playerId: Int) -> Bool {
        guard state == .challenge else {
            print("Player \(playerId) challenge failed.")
            
            return false
        }
        
        print("Player \(playerId) challenge succeeded.")
        
        state = .collection
        
        print("Collecting…")
        
        executeChallenge(playerId: playerId)
        
        return true
    }
    
    func executeChallenge(playerId: Int) {
        let lastTurn = turns.last!
        let recipientId = lastTurn.isCheat ? lastTurn.playerId : playerId
        let cards = turns.reduce([]) { $0 + $1.cards }
        
        turns.removeAll()
        
        let index = players.firstIndex { $0.player.id == recipientId }!
        
        players[index].accept(cards)
        
        print("Player \(players[index].player.name) gets \(cards.count) card(s).")
    }
    
    func endGame() {
        print("Game ended")
        
        isInProgress = false
    }
    
    
    func gameOver() {
        print("Game over")
        
        isInProgress = false
        //        print("\n\nThanks for playing!\n")
        //        startGame(player: getPlayer(prompt: "Play again? Enter your name:"))
    }
}
