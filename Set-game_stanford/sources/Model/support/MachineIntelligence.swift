//
//  MachineIntelligence.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 22/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import Foundation

fileprivate let cardInSetCount = 3

class MachineIntelligence {
    private unowned var game: GameLogic
    private unowned var gameMode: MultiPlayerGame
    
    private var haveToFindSet: Bool {
        return true
    }
    
    private var turnTimeInterval: TimeInterval {
        return 3.0
    }
    
    init(gameMode: MultiPlayerGame, game: GameLogic) {
        self.game = game
        self.gameMode = gameMode
    }
    
    func startPlaying() {
        if haveToFindSet {
            while game.howManySets == 0 {
                game.deal3MoreCards()
                if game.deck.isEmpty {
                    return
                }
            }
            
            if let indices = game.setIndices {
                chooseCards(withIndices: indices)
            }
        } else {
            var randomIndices = [Int]()
            for (index, card) in game.cards.enumerated() {
                if !card.isMatched {
                    randomIndices.append(index)
                    if randomIndices.count == cardInSetCount {
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
            Timer.scheduledTimer(withTimeInterval: Double(i) * turnTime / Double(cardInSetCount), repeats: false) { [weak self] _ in
                self?.gameMode.chooseCard(withIndex: index)
            }
        }
    }
}
