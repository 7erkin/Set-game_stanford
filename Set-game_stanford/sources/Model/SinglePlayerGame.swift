//
//  SinglePlayerMode.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 22/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import Foundation

fileprivate var initialCardCount = 12

class SinglePlayerGame: GameMode {
    private lazy var game: Game = {
        return Game(gameMode: self, initialCardCount: initialCardCount)
    }()
    
    private var subscribers = [Subscribing]()
    
    private(set) var score = 0
    
    func subscribe(_ subscriber: Subscribing) {
        if subscribers.contains(where: { $0 === subscriber }) { return }
        
        subscribers.append(subscriber)
    }
    
    var cards: [Card] { return game.cards }
    
    var deck: [Card] { return game.deck }
    
    func hint() {
        game.hint()
        notify()
    }
    
    func chooseCard(withIndex indexTappedCard: Int) {
        game.chooseCard(withIndex: indexTappedCard)
        notify()
    }
    
    func deal3MoreCards() {
        game.deal3MoreCards()
        notify()
    }
    
    func startNewGame() {
        game.startNewGame(initialCardCount: initialCardCount)
        notify()
    }
    
    func addPoint() {
        score += 1
    }
    
    func removePoint(reason: ChangingPointReason) {
        score -= 1
    }
    
    func resetPoints() {
        score = 0
    }
    
    private func notify() {
        subscribers.forEach { $0.update() }
    }
}
