//
//  Game.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 12/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import Foundation

fileprivate let cardCountToMatch = 3
fileprivate let cardToDeal = 3

struct Game {
    private(set) var cards = [Card]()
    
    private(set) var deck: [Card] = {
        let content: [[Sign]] = Sign.all.flatMap { s1 in
            Sign.all.flatMap { s2 in
                Sign.all.flatMap { s3 in
                    Sign.all.map { [s1, s2, s3, $0] }
                }
            }
        }
        
        let cards = content.map{ Card(signs: $0) }
        return cards.shuffled()
    }()
    
    init(initialCardCount: Int) {
        for _ in 0..<initialCardCount {
            cards.append(deck.removeLast())
        }
    }
    
    mutating func chooseCard(withIndex index: Int) {
        cards[index].isChoosen = true
        
        let choosenCards = cards.filter{ $0.isChoosen }
        if choosenCards.count != cardCountToMatch { return }
        
        if choosenCards.isMatched() {
            cards = cards.map{ card in
                if deck.isEmpty {
                    var copy = card
                    copy.isMatched = true
                    return copy
                }
                
                return deck.removeLast()
            }
        } else {
            cards = cards.map{ var copy = $0; copy.isChoosen = false; return copy }
        }
    }
    
    mutating func dealThreeMoreCards() {
        if deck.isEmpty { return }
        
        for _ in 0..<cardToDeal {
            let card = deck.removeLast()
            if let index = cards.firstIndex(where: { $0.isMatched }) {
                cards[index] = card
            } else {
                cards.append(card)
            }
        }
    }
}
