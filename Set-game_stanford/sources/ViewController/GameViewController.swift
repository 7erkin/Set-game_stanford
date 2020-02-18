//
//  ViewController.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 12/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet var cardRows: [UIStackView]!
    @IBOutlet var deckCardCountLabel: UILabel!
    @IBOutlet var resultMatchingLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    @IBAction func onDealThreeMoreCardTouched(_ sender: UIButton) {
        game.dealThreeMoreCards()
        updateViewWithModel()
    }
    
    private lazy var cards: [CardView] = {
        let cards = cardRows.reduce([UIView](), { $0 + $1.subviews }).map{ $0 as! CardView }
        return cards
    }()
    
    private var game: Game = Game(initialCardCount: 12)
    
    @objc func handleCardTap(sender: UITapGestureRecognizer) {
        guard
            let tappedCard = sender.view as? CardView,
            let indexTappedCard = cards.firstIndex(of: tappedCard)
        else { return }
        
        game.chooseCard(withIndex: indexTappedCard)
        updateViewWithModel()
    }
    
    private func updateViewWithModel() {
        deckCardCountLabel.text = "Deck: \(game.deck.count)"
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
            } else {
                card.isVisible = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCards()
        updateViewWithModel()
    }
    
    private func configureCards() {
        for (_, card) in cards.enumerated() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(sender:)))
            card.addGestureRecognizer(tapGesture)
        }
    }
}

