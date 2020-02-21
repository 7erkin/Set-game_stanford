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
    private var subscribers = [Subscribing]()
    
    private(set) var cards = [Card]()
    private(set) var score = 0
    
    private(set) var deck: [Card] = createDeck()
    
    private var hasSet: Bool {
        return cards.some3Permutation { $0.map{ cards[$0] }.isMatched() }
    }
    
    private var howManySets: Int {
        var result = 0
        cards.some3Permutation {
            let cards = $0.map{ self.cards[$0] }
            if cards.isMatched() { result += 1 }
            
            return false
        }
        return result
    }
    
    init(initialCardCount: Int) {
        dealFirstCards(initialCardCount)
    }
    
    mutating func subscribe(_ subscriber: Subscribing) {
        if subscribers.contains(where: { $0 === subscriber }) { return }
        
        subscribers.append(subscriber)
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
        
        if hasSet { score -= 1 }
        
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
        cards = []
        dealFirstCards(initialCardCount)
    }
    
    mutating func hint() {
        cards.some3Permutation {
            let cards = $0.map{ self.cards[$0] }
            if cards.isMatched() {
                for index in $0 {
                    self.cards[index].isHint = true
                }
                return true
            }
            return false
        }
    }
    
    private func notify() {
        subscribers.forEach { $0.update() }
    }
}
