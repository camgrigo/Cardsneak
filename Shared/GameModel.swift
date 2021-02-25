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
    
    var mainPlayer: UserPlayer
    
    init(mainPlayer: UserPlayer) {
        self.mainPlayer = mainPlayer
    }
    
    @Published var playerCarousel = Carousel<Player>()
    var players: [Player] {
        playerCarousel.contents
    }
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
        playerCarousel = Carousel([
            mainPlayer,
            AIPlayer(name: nameGenerator.generate(), id: 1),
            AIPlayer(name: nameGenerator.generate(), id: 2),
            AIPlayer(name: nameGenerator.generate(), id: 3),
            AIPlayer(name: nameGenerator.generate(), id: 4)
        ])
        
        print(players.map { "\($0.id): \($0.name)" })
    }
    
    func dealCards() {
        state = .deal
        print("Dealing cards…")
        
        var cards = Deck().shuffled().cards
        
        print("Created deck with \(cards.count) cards.")
        
        while !cards.isEmpty {
            let card = cards.popLast()!
            var player = playerCarousel.next()
            
            player.accept(card)
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
        player.getPlay(rank: rank, handler: receivePlay)
    }
    
    func receivePlay(cards: [PlayingCard]) {
        state = .discard
        print("Discarding…")
        
        let turn = Turn(
            id: (turns.last?.id ?? 0 + 1),
            playerId: playerCarousel.currentElement.id,
            rank: rankCarousel.currentElement,
            cards: cards
        )
        turns.append(turn)
        
        finish(turn)
    }
    
    func finish(_ turn: Turn) {
        let currentPlayer = playerCarousel.currentElement
        
        state = .challenge
        print("Challenging open")
        
        players
            .filter { $0.id != currentPlayer.id }
            .forEach { playerController in
                playerController.shouldChallenge(
                    player: (playerId: currentPlayer.id, cardCount: currentPlayer.cards.count),
                    rank: rankCarousel.currentElement
                ) { isChallenging in
                    if isChallenging,
                       let lastTurn = self.turns.last,
                       lastTurn.id == turn.id {
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
        
        let recipientIndex = playerCarousel.contents.firstIndex { $0.id == recipientId }!
        let cards = turns.reduce([]) { $0 + $1.cards }
        
        playerCarousel.contents[recipientIndex].accept(cards)
        
        turns.removeAll(keepingCapacity: true)
        
        print("Player \(playerCarousel.contents[recipientIndex].name) gets \(cards.count) card(s).")
    }
    
    func endGame() {
        print("Game over")
        state = .over
    }
    
}
