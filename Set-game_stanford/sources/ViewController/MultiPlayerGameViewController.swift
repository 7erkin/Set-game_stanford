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
            let indexTappedCard = cardBoardView.cardsOnBoard.firstIndex(of: tappedCard),
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
        for (_, card) in cardBoardView.cardsOnBoard.enumerated() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(sender:)))
            card.addGestureRecognizer(tapGesture)
        }
    }
    
    func update() {
        
    }
}
