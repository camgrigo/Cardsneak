//
//  PlayingCard.swift
//  Cheat
//
//  Created by Cameron Grigoriadis on 2/3/21.
//

import Foundation
import SwiftUI

struct PlayingCard: Equatable, Hashable, Identifiable {
    var id: String { "\(suit)\(rank)" }
    
    let suit: PlayingCard.Suit
    let rank: PlayingCard.Rank
}

extension PlayingCard {
    
    static var suitCount: Int { Suit.allCases.count }
    
    static var rankCount: Int { Rank.allCases.count }
    
    enum Suit: CaseIterable, CustomStringConvertible {
        case spade, diamond, club, heart
        
        var description: String {
            switch self {
            case .spade:
                return "♠️"
            case .diamond:
                return "♦️"
            case .club:
                return "♣️"
            case .heart:
                return "♥️"
            }
        }
        
        var color: Color {
            switch self {
            case .spade, .club:
                return .primary
            case .diamond, .heart:
                return .red
            }
        }
    }

    enum Rank: Int, CaseIterable, CustomStringConvertible {
        case ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king
        
        var description: String {
            switch self {
            case .ace:   return "A"
            case .two:   return "2"
            case .three: return "3"
            case .four:  return "4"
            case .five:  return "5"
            case .six:   return "6"
            case .seven: return "7"
            case .eight: return "8"
            case .nine:  return "9"
            case .ten:   return "10"
            case .jack:  return "J"
            case .queen: return "Q"
            case .king:  return "K"
            }
        }
    }
    
}
