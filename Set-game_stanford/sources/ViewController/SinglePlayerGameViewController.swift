//
//  ViewController.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 12/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import UIKit

fileprivate var initialCardCount = 12

class SinglePlayerGameViewController: UIViewController, Subscribing, MatchedCardReplacing {
    @IBOutlet private var deckCardCountLabel: UILabel!
    @IBOutlet private var scoreLabel: UILabel!
    @IBOutlet var cardBoardView: CardBoardView! {
        didSet { self.cardBoardView.matchedCardReplacingDelegate = self }
    }
    @IBOutlet var gamePanelView: GamePanelView! {
        didSet {
            self.gamePanelView.hintButton.addTarget(self, action: #selector(onHintButtonTapped(_:)), for: UIControl.Event.touchUpInside)
            self.gamePanelView.newGameButton.addTarget(self, action: #selector(onNewGameButtonTapped(_:)), for: UIControl.Event.touchUpInside)
            self.gamePanelView.deal3MoreCardsButton.addTarget(self, action: #selector(onDeal3MoreCardsButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        }
    }
    
    @IBAction private func onDeal3MoreCardsButtonTapped(_ sender: UIButton) {
        game.deal3MoreCards()
        update()
    }
    
    @IBAction private func onHintButtonTapped(_ sender: UIButton) {
        game.hint()
    }
    
    @IBAction private func onNewGameButtonTapped(_ sender: UIButton) {
        game.startNewGame()
    }
    
    private lazy var game: SinglePlayerGame = {
        var game = SinglePlayerGame()
        game.subscribe(subscriber: self)
        return game
    }()
    
    @objc private func handleCardTap(sender: UITapGestureRecognizer) {
        guard
            let tappedCard = sender.view as? CardView,
            let indexTappedCard = cardBoardView.cardsOnBoard.firstIndex(of: tappedCard),
            indexTappedCard < game.cards.count
        else { return }
        
        game.chooseCard(withIndex: indexTappedCard)
    }
    
    func update() {
        deckCardCountLabel.text = "Deck: \(game.deck.count)"
        scoreLabel.text = "Score: \(game.score)"
        gamePanelView.setsOnBoardCount = game.setsOnBoardCount
        for (index, cardOnBoard) in game.cards[0..<cardBoardView.cardsOnBoard.count].enumerated() {
            let cardView = cardBoardView.cardsOnBoard[index]
            configure(cardView, with: cardOnBoard)
        }
        for newDealtCard in game.cards[cardBoardView.cardsOnBoard.count...] {
            let cardView = CardView()
            configure(cardView, with: newDealtCard)
            cardBoardView.add(cardView)
        }
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
    
    private func configure(_ cardView: CardView, with cardModel: Card) {
        cardView.applySigns(
            colorSign: cardModel.signs[0],
            fillingSign: cardModel.signs[1],
            figureSign: cardModel.signs[2],
            figureCountSign: cardModel.signs[3]
        )
        cardView.isChoosen = cardModel.isChoosen
        cardView.isHinted = cardModel.isHint
        cardView.isMatched = cardModel.isMatched
    }
    
    // MARK: MatchedCardReplacing impl
    func replaceMatchedCards() {
        game.replaceMatchedCards()
    }
}
