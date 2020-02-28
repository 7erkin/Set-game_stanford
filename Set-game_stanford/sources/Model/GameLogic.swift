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
fileprivate let initialCardCount = 12

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

class GameLogic {
    private unowned var delegate: GameScoreManaging
    private(set) var cards = [Card]()
    private(set) var deck: [Card] = createDeck()
    
    private var hasSet: Bool {
        return cards.some3UniquePermutation { $0.map{ cards[$0] }.isMatched() }
    }
    
    var howManySets: Int {
//        var setCount = 0
//        cards.some3UniquePermutation {
//            let cards = $0.map{ self.cards[$0] }
//            if cards.isMatched() {
//                setCount += 1
//            }
//
//            return false
//        }
        return 1
    }
    
    var setIndices: [Int]? {
        var indices: [Int]? = nil
        cards.some3UniquePermutation {
            let cards = $0.map{ self.cards[$0] }
            if cards.isMatched() {
                indices = $0
                return true
            }
            return false
        }
        return indices
    }
    
    init(gameScoreManager: GameScoreManaging) {
        delegate = gameScoreManager
        dealFirstCards(initialCardCount)
    }
    
    private func dealFirstCards(_ cardCount: Int) {
        for _ in 0..<cardCount {
            cards.append(deck.removeLast())
        }
    }
    
    func chooseCard(withIndex index: Int) {
        cards[index].isChoosen = true
        
        for index in cards.indices {
            cards[index].isHint = false
        }
        
        let choosenCards = cards.filter{ $0.isChoosen }
        if choosenCards.count != cardCountToMatch { return }
        
        if choosenCards.isMatched() {
            delegate.addPoint()
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
            delegate.removePoint(reason: .WrongSet)
            cards = cards.map{ var copy = $0; copy.isChoosen = false; return copy }
        }
    }
    
    func deal3MoreCards() {
        if deck.isEmpty { return }
        
        if hasSet {
            delegate.removePoint(reason: .Deal3More)
        }
        
        for _ in 0..<cardToDeal {
            let card = deck.removeLast()
            if let index = cards.firstIndex(where: { $0.isMatched }) {
                cards[index] = card
            } else {
                cards.append(card)
            }
        }
    }
    
    func startNewGame() {
        deck = createDeck()
        delegate.resetPoints()
        cards = []
        dealFirstCards(initialCardCount)
    }
    
    func hint() {
        cards.some3UniquePermutation {
            let cards = $0.map{ self.cards[$0] }
            if cards.isMatched() {
                $0.forEach{ self.cards[$0].isHint = true }
                return true
            }
            
            return false
        }
    }
    
    func replaceMatchedCards() {}
}
