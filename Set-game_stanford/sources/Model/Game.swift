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

fileprivate func createDeck() -> [Card] {
    let content: [[Sign]] = Sign.all.flatMap { s1 in
        Sign.all.flatMap { s2 in
            Sign.all.flatMap { s3 in
                Sign.all.map { [s1, s2, s3, $0] }
            }
        }
    }
    
    let cards = content.map{ Card(signs: $0) }
    return cards.shuffled()
}

struct Game {
    private(set) var cards = [Card]()
    private(set) var hasSet = false
    private(set) var score = 0
    
    private(set) var deck: [Card] = createDeck()
    
    init(initialCardCount: Int) {
        dealFirstCards(initialCardCount)
    }
    
    mutating private func dealFirstCards(_ cardCount: Int) {
        for _ in 0..<cardCount {
            cards.append(deck.removeLast())
        }
    }
    
    mutating func chooseCard(withIndex index: Int) {
        cards[index].isChoosen = true
        
        for index in cards.indices {
            cards[index].isHint = false
        }
        
        let choosenCards = cards.filter{ $0.isChoosen }
        if choosenCards.count != cardCountToMatch { return }
        
        if choosenCards.isMatched() {
            score += 1
            cards = cards.map{ card in
                if card.isChoosen {
                    if deck.isEmpty {
                        var copy = card
                        copy.isMatched = true
                        copy.isChoosen = false
                        return copy
                    }
                    return deck.removeLast()
                }
                return card
            }
        } else {
            score -= 1
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
    
    mutating func startNewGame(initialCardCount: Int) {
        deck = createDeck()
        score = 0
        hasSet = false
        cards = []
        dealFirstCards(initialCardCount)
    }
    
    mutating func hint() {
        for i in 0..<cards.count - 2 {
            for j in 1..<cards.count - 1 {
                for k in 2..<cards.count {
                    let arr = [cards[i], cards[j], cards[k]]
                    if arr.isMatched() {
                        print("======= \(arr)")
                        cards[i].isHint = true
                        cards[j].isHint = true
                        cards[k].isHint = true
                        return
                    }
                }
            }
        }
    }
}
