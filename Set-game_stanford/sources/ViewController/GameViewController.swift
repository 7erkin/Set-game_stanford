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

class GameViewController: UIViewController, Subscribing {
    @IBOutlet private var cardRows: [UIStackView]!
    @IBOutlet private var deckCardCountLabel: UILabel!
    @IBOutlet private var resultMatchingLabel: UILabel!
    @IBOutlet private var scoreLabel: UILabel!
    
    @IBAction private func onDealThreeMoreCardTouched(_ sender: UIButton) {
        game.dealThreeMoreCards()
        update()
    }
    
    @IBAction private func onHintTapped(_ sender: UIButton) {
        game.hint()
    }
    
    @IBAction private func onStartNewGameTapped(_ sender: UIButton) {
        game.startNewGame(initialCardCount: initialCardCount)
    }
    
    private lazy var cards: [CardView] = {
        let cards = cardRows.reduce([UIView](), { $0 + $1.subviews }).map{ $0 as! CardView }
        return cards
    }()
    
    private lazy var game: Game = {
        var game = Game(initialCardCount: initialCardCount)
        game.subscribe(self)
        return game
    }()
    
    @objc private func handleCardTap(sender: UITapGestureRecognizer) {
        guard
            let tappedCard = sender.view as? CardView,
            let indexTappedCard = cards.firstIndex(of: tappedCard),
            indexTappedCard < game.cards.count
        else { return }
        
        game.chooseCard(withIndex: indexTappedCard)
    }
    
    func update() {
        deckCardCountLabel.text = "Deck: \(game.deck.count)"
        scoreLabel.text = "Score: \(game.score)"
        for (index, card) in cards.enumerated() {
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
        for (_, card) in cards.enumerated() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(sender:)))
            card.addGestureRecognizer(tapGesture)
        }
    }
}
