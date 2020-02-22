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
        
        mutating func nextTurn() {
            switch self {
                case .Human:
                    self = .Machine
                case .Machine:
                    self = .Human
            }
        }
    }
    
    private lazy var machineIntelligence: MachineIntelligence = {
        var machineIntelligence = MachineIntelligence(gameMode: self, game: self.game)
        return machineIntelligence
    }()
    
    private(set) var turn: Turn = Turn.Human {
        didSet {
            if self.turn == .Machine { self.machineIntelligence.startPlaying() }
        }
    }
    
    private lazy var game: Game = {
        return Game(gameMode: self)
    }()
    
    private var subscribers = [Subscribing]()
    
    private(set) var humanScore = 0
    private(set) var machineScore = 0
    
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
        game.startNewGame()
        notify()
    }
    
    func addPoint() {
        if turn == .Human {
            humanScore += 1
        } else {
            machineScore += 1
        }
        
        turn.nextTurn()
    }
    
    func removePoint(reason: PointChangingReason) {
        if turn == .Human {
            humanScore -= 1
        } else {
            machineScore -= 1
        }
        
        if reason == .WrongSet {
            turn.nextTurn()
        }
    }
    
    func resetPoints() {
        humanScore = 0
        machineScore = 0
    }
    
    private func notify() {
        subscribers.forEach { $0.update() }
    }
}
