//
//  GameModel.swift
//  Cardsneak
//
//  Created by Cameron Grigoriadis on 2/8/21.
//

import Foundation

class GameModel: ObservableObject {
    
    let nameGenerator = NameGenerator()
    
    @Published var turnCarousel = Carousel<Int>()
    
    var rankCarousel = Carousel(PlayingCard.Rank.allCases)
    var turns = [Turn]()
    var stack: [PlayingCard] {
        turns.reduce([]) {
            var a = $0
            a.append(contentsOf: $1.cards)
            return a
        }
    }
    
    
    @Published var userPlayer = UserPlayer(name: "", id: 0)
    
    @Published var players = [Player]()
    
    
    var allHaveCards: Bool {
        players.allSatisfy { !$0.cards.isEmpty }
    }
    
    
    enum GameState {
        case loading, deal, discard, challenge, collection, over
    }
    
    @Published var state = GameState.loading
    
    
    init() {
        players = [
            userPlayer,
            AIPlayer(name: nameGenerator.generate(), id: 1),
            AIPlayer(name: nameGenerator.generate(), id: 2),
            AIPlayer(name: nameGenerator.generate(), id: 3)
        ]
        turnCarousel = Carousel(players.map { $0.id })
        
        print(players.map { "\($0.id): \($0.name)" })
    }
    
    
    func dealCards() {
        state = .deal
        print("Dealing cards…")
        
        var cards = Deck().shuffled().cards
        
        print("Created deck with \(cards.count) cards.")
        
        while !cards.isEmpty {
            let card = cards.popLast()!
            
            players[turnCarousel.next()].accept(card)
        }
        
        print(players.map { "Player \($0.id) Card Count: \($0.cards.count)" })
    }
    
    func startGame() {
        print("Game starting")
        
        dealCards()
        
        turnCarousel.spin()
        print("Starting player:", turnCarousel.currentElement)
        
        startTurn()
    }
    
    func startTurn() {
        let turnPlayerId = turnCarousel.next()
        let rank = rankCarousel.next()
        
        print("Turn: Player \(players[turnPlayerId]), Rank: \(rank)")
        players[turnPlayerId].getPlay(rank: rank, handler: receivePlay)
    }
    
    func receivePlay(cards: [PlayingCard]) {
        state = .discard
        print("Discarding…")
        
        let turn = Turn(
            id: (turns.last?.id ?? 0 + 1),
            playerId: turnCarousel.currentElement,
            rank: rankCarousel.currentElement,
            cards: cards
        )
        turns.append(turn)
        
        finish(turn)
    }
    
    func finish(_ turn: Turn) {
        let currentPlayer = players[turnCarousel.currentElement]
        
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
        
        precondition(
            players.reduce([]) { $0 + $1.cards }.count + stack.count ==
                PlayingCard.Rank.allCases.count * PlayingCard.Suit.allCases.count
        )
        
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
        
        let recipientIndex = players.firstIndex { $0.id == recipientId }!
        let cards = turns.reduce([]) { $0 + $1.cards }
        
        players[recipientIndex].accept(cards)
        
        turns.removeAll(keepingCapacity: true)
        
        print("Player \(players[recipientIndex].name) gets \(cards.count) card(s).")
    }
    
    func endGame() {
        print("Game over")
        state = .over
    }
    
}
