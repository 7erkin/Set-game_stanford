//
//  MultiPlayerGame.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 22/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import Foundation

class MultiPlayerGame: GameScoreManaging {
    enum Turn {
        case Human
        case Machine
    }
    
    private(set) var turn: Turn = Turn.Human
    
    private var subscriberList = SubscriberList()
    
    private lazy var machineIntelligence: MachineIntelligence = {
        var machineIntelligence = MachineIntelligence(gameMode: self, game: self.gameLogic)
        return machineIntelligence
    }()
    
    private lazy var gameLogic: GameLogic = {
        return GameLogic(gameScoreManager: self)
    }()
    
    private(set) var humanScore = 0
    private(set) var machineScore = 0
    
    func subscribe(subscriber: Subscribing) {
        subscriberList.add(subscriber)
    }
    
    func nextTurn() {
        switch turn {
            case .Human:
                turn = .Machine
            case .Machine:
                turn = .Human
        }
    }
    
    var cards: [Card] { return gameLogic.cards }
    
    var deck: [Card] { return gameLogic.deck }
    
    func hint() {
        gameLogic.hint()
        subscriberList.notifyAll()
    }
    
    func chooseCard(withIndex indexTappedCard: Int) {
        gameLogic.chooseCard(withIndex: indexTappedCard)
        subscriberList.notifyAll()
        
        let choosenCards = gameLogic.cards.filter{ $0.isChoosen }
        if turn == .Machine && choosenCards.isEmpty {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
                DispatchQueue.main.async {
                    self?.machineIntelligence.startPlaying()
                }
            }
        }
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
        if turn == .Human {
            humanScore += 1
        } else {
            machineScore += 1
        }
        
        nextTurn()
        subscriberList.notifyAll()
    }
    
    func removePoint(reason: PointChangingReason) {
        if turn == .Human {
            humanScore -= 1
        } else {
            machineScore -= 1
        }
        
        if reason == .WrongSet {
            nextTurn()
        }
        
        subscriberList.notifyAll()
    }
    
    func resetPoints() {
        humanScore = 0
        machineScore = 0
        subscriberList.notifyAll()
    }
}
