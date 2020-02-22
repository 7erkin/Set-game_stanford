//
//  SinglePlayerMode.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 22/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import Foundation

class SinglePlayerGame: GameScoreManaging {
    private lazy var gameLogic: GameLogic = {
        return GameLogic(gameScoreManager: self)
    }()
    
    private var subscriberList = SubscriberList()
    
    private(set) var score = 0
    
    var cards: [Card] { return gameLogic.cards }
    
    var deck: [Card] { return gameLogic.deck }
    
    func subscribe(subscriber: Subscribing) {
        subscriberList.add(subscriber)
    }
    
    func hint() {
        gameLogic.hint()
        subscriberList.notifyAll()
    }
    
    func chooseCard(withIndex indexTappedCard: Int) {
        gameLogic.chooseCard(withIndex: indexTappedCard)
        subscriberList.notifyAll()
    }
    
    func deal3MoreCards() {
        gameLogic.deal3MoreCards()
        subscriberList.notifyAll()
    }
    
    func startNewGame() {
        gameLogic.startNewGame()
        subscriberList.notifyAll()
    }
    
    func addPoint() {
        score += 1
        subscriberList.notifyAll()
    }
    
    func removePoint(reason: PointChangingReason) {
        score -= 1
        subscriberList.notifyAll()
    }
    
    func resetPoints() {
        score = 0
        subscriberList.notifyAll()
    }
}
