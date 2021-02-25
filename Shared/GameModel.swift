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
    var players = [Player]()
    var rankCarousel = Carousel(PlayingCard.Rank.allCases)
    var turns = [Turn]()
    var stack: [PlayingCard] {
        turns.reduce([]) {
            var a = $0
            a.append(contentsOf: $1.cards)
            return a
        }
    }
    
    var allHaveCards: Bool {
        players.allSatisfy { !$0.cards.isEmpty }
    }
    
    
    enum GameState {
        case loading, deal, discard, challenge, collection, over
    }
    
    @Published var state = GameState.loading
    
    
    func configurePlayers() {
        players = [
            mainPlayer!,
            AIPlayerController(name: nameGenerator.generate(), id: 1),
            AIPlayerController(name: nameGenerator.generate(), id: 2),
            AIPlayerController(name: nameGenerator.generate(), id: 3),
            AIPlayerController(name: nameGenerator.generate(), id: 4)
        ]
        playerCarousel = Carousel(players.map { $0.id })
        
        print(players.map { "\($0.id): \($0.name)" })
    }
    
    func dealCards() {
        state = .deal
        print("Dealing cards…")
        
        var cards = Deck().shuffled().cards
        
        print("Created deck with \(cards.count) cards.")
        
        while !cards.isEmpty {
            let card = cards.popLast()!
            
            if let index = players.firstIndex(where: { $0.id == playerCarousel.next() }) {
                players[index].accept(card)
                print("Player \(players[index].id) Card Count: \(players[index].cards.count)")
            }
        }
        
        print(players.map { "Player \($0.id) Card Count: \($0.cards.count)" })
    }
    
    func startGame() {
        print("Game starting")
        
        configurePlayers()
        dealCards()
        
        playerCarousel.spin()
        print("Starting player:", playerCarousel.currentElement)
        
        startTurn()
    }
    
    func startTurn() {
        let player = playerCarousel.next()
        let rank = rankCarousel.next()
        print("Turn: Player \(player), Rank: \(rank)")
        
        players
            .first { $0.id == player }!
            .getPlay(rank: rank, handler: receivePlay)
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
        
        finish(turn)
    }
    
    func finish(_ turn: Turn) {
        let currentPlayerId = playerCarousel.currentElement
        let currentPlayer = players.first { $0.id == currentPlayerId }!
        
        state = .challenge
        print("Challenging open")
        
        players
            .filter { $0.id != currentPlayerId }
            .forEach { playerController in
                playerController.shouldChallenge(player: (playerId: currentPlayerId, cardCount: currentPlayer.cards.count), rank: rankCarousel.currentElement) { isChallenging in
                    if isChallenging, let lastTurn = self.turns.last, lastTurn.id == turn.id {
                        _ = self.receiveChallenge(playerId: playerController.id)
                    }
                }
            }
        
        if allHaveCards {
            startTurn()
            
        } else {
            endGame()
        }
    }
    
    func receiveChallenge(playerId: Int) -> Bool {
        guard state == .challenge else {
            print("Player \(playerId) challenge failed.")
            
            return false
        }
        
        print("Player \(playerId) challenge succeeded.")
        
        state = .collection
        print("Challenging closed.\nCollecting…")
        
        executeChallenge(playerId: playerId)
        
        return true
    }
    
    func executeChallenge(playerId: Int) {
        let lastTurn = turns.last!
        let recipientId = lastTurn.isCheat ? lastTurn.playerId : playerId
        let cards = turns.reduce([]) { $0 + $1.cards }
        
        turns.removeAll()
        
        let index = players.firstIndex { $0.id == recipientId }!
        
        players[index].accept(cards)
        
        print("Player \(players[index].name) gets \(cards.count) card(s).")
    }
    
    func endGame() {
        print("Game over")
        state = .over
    }
    
}
