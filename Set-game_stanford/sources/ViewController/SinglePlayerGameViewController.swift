//
//  ViewController.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 12/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import UIKit

fileprivate var initialCardCount = 12

protocol Subscribing: class {
    func update()
}

class SinglePlayerGameViewController: UIViewController, Subscribing {
    @IBOutlet private var deckCardCountLabel: UILabel!
    @IBOutlet private var resultMatchingLabel: UILabel!
    @IBOutlet private var scoreLabel: UILabel!
    @IBOutlet var cardBoardView: CardBoardView!
    
    @IBAction private func onDealThreeMoreCardTouched(_ sender: UIButton) {
        game.deal3MoreCards()
        update()
    }
    
    @IBAction private func onHintTapped(_ sender: UIButton) {
        game.hint()
    }
    
    @IBAction private func onStartNewGameTapped(_ sender: UIButton) {
        game.startNewGame()
    }
    
    private lazy var game: SinglePlayerGame = {
        var game = SinglePlayerGame()
        game.subscribe(self)
        return game
    }()
    
    @objc private func handleCardTap(sender: UITapGestureRecognizer) {
        guard
            let tappedCard = sender.view as? CardView,
            let indexTappedCard = cardBoardView.cards.firstIndex(of: tappedCard),
            indexTappedCard < game.cards.count
        else { return }
        
        game.chooseCard(withIndex: indexTappedCard)
    }
    
    func update() {
        deckCardCountLabel.text = "Deck: \(game.deck.count)"
        scoreLabel.text = "Score: \(game.score)"
        for (index, card) in cardBoardView.cards.enumerated() {
            if index < game.cards.count {
                if game.cards[index].isMatched {
                    card.isVisible = false
                    continue
                }
                let signs = game.cards[index].signs
                card.applySigns(colorSign: signs[0], fillingSign: signs[1], figureSign: signs[2], figureCountSign: signs[3])
                card.isChoosen = game.cards[index].isChoosen
                card.isVisible = true
                card.isHint = game.cards[index].isHint
            } else {
                card.isVisible = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCards()
        update()
    }
    
    private func configureCards() {
        for (_, card) in cardBoardView.cards.enumerated() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(sender:)))
            card.addGestureRecognizer(tapGesture)
        }
    }
}