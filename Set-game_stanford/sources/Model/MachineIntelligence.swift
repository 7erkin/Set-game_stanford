//
//  MachineIntelligence.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 22/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import Foundation

class MachineIntelligence {
    private unowned var game: Game
    private unowned var gameMode: MultiPlayerGame
    
    private var haveToFindSet: Bool {
        return true
    }
    
    private var turnTimeInterval: TimeInterval {
        return 10.0
    }
    
    init(gameMode: MultiPlayerGame, game: Game) {
        self.game = game
        self.gameMode = gameMode
    }
    
    func startPlaying() {
        if haveToFindSet {
            repeat {
                game.deal3MoreCards()
            } while game.howManySets == 0
            
            if let indices = game.setIndices {
                chooseCards(withIndices: indices)
            }
        } else {
            var randomIndices = [Int]()
            for (index, card) in game.cards.enumerated() {
                if !card.isMatched {
                    randomIndices.append(index)
                    if randomIndices.count == 3 {
                        chooseCards(withIndices: randomIndices)
                        return
                    }
                }
            }
        }
    }
    
    private func chooseCards(withIndices indices: [Int]) {
        let turnTime = turnTimeInterval
        for (i, index) in indices.enumerated() {
            Timer.scheduledTimer(withTimeInterval: Double(i) * turnTime / 3, repeats: false) { [weak self] _ in self?.gameMode.chooseCard(withIndex: index) }
        }
    }
}
