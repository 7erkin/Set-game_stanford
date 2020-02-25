//
//  MultiPlayerGameViewController.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 22/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import UIKit

class MultiPlayerGameViewController: UIViewController, Subscribing {
    @IBOutlet private var gamePanelView: GamePanelView! {
        didSet {
            self.gamePanelView.hintButton.addTarget(self, action: #selector(onHintButtonTapped(_:)), for: UIControl.Event.touchUpInside)
            self.gamePanelView.newGameButton.addTarget(self, action: #selector(onNewGameButtonTapped(_:)), for: UIControl.Event.touchUpInside)
            self.gamePanelView.deal3MoreCardsButton.addTarget(self, action: #selector(onDeal3MoreCardsButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        }
    }
    @IBOutlet private var humanScoreLabel: UILabel!
    @IBOutlet private var machineScoreLabel: UILabel!
    @IBOutlet private var deckCardCountLabel: UILabel!
    @IBOutlet private var cardBoardView: CardBoardView!
    
    private lazy var game: MultiPlayerGame = {
        var game = MultiPlayerGame()
        game.subscribe(subscriber: self)
        return game
    }()
    
    @IBAction private func onHintButtonTapped(_ sender: UIButton) {
        game.hint()
    }
    
    @IBAction private func onNewGameButtonTapped(_ sender: UIButton) {
        game.startNewGame()
    }
    
    @IBAction private func onDeal3MoreCardsButtonTapped(_ sender: UIButton) {
        game.deal3MoreCards()
    }
    
    @objc private func handleCardTap(sender: UITapGestureRecognizer) {
        guard
            let tappedCard = sender.view as? CardView,
            let indexTappedCard = cardBoardView.cards.firstIndex(of: tappedCard),
            indexTappedCard < game.cards.count
        else { return }
        
        game.chooseCard(withIndex: indexTappedCard)
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
    
    func update() {
        deckCardCountLabel.text = "Deck: \(game.deck.count)"
        humanScoreLabel.text = "Human score: \(game.humanScore)"
        machineScoreLabel.text = "Machine score: \(game.machineScore)"
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
}
