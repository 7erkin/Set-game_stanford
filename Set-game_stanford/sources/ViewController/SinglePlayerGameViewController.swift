//
//  ViewController.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 12/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import UIKit

fileprivate var initialCardCount = 12

class SinglePlayerGameViewController: UIViewController, Subscribing, MatchedCardReplacing, CardTapping {
    @IBOutlet private var deckCardCountLabel: UILabel!
    @IBOutlet private var scoreLabel: UILabel!
    @IBOutlet var cardBoardView: CardBoardView! {
        didSet {
            self.cardBoardView.matchedCardReplacingDelegate = self
            self.cardBoardView.cardTappingDelegate = self
            let deal3MoreCardsGesture = UISwipeGestureRecognizer(target: self, action: #selector(onDeal3MoreCardsButtonTapped(_:)))
            deal3MoreCardsGesture.direction = .down
            self.cardBoardView.addGestureRecognizer(deal3MoreCardsGesture)
        }
    }
    @IBOutlet var gamePanelView: GamePanelView! {
        didSet {
            self.gamePanelView.hintButton.addTarget(self, action: #selector(onHintButtonTapped(_:)), for: UIControl.Event.touchUpInside)
            self.gamePanelView.newGameButton.addTarget(self, action: #selector(onNewGameButtonTapped(_:)), for: UIControl.Event.touchUpInside)
            self.gamePanelView.deal3MoreCardsButton.addTarget(self, action: #selector(onDeal3MoreCardsButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        }
    }
    
    @IBAction private func onDeal3MoreCardsButtonTapped(_ sender: Any) {
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
    
    func update() {
        deckCardCountLabel.text = "Deck: \(game.deck.count)"
        scoreLabel.text = "Score: \(game.score)"
        gamePanelView.setsOnBoardCount = game.setsOnBoardCount
        gamePanelView.deal3MoreCardsButton.isHidden = game.deck.isEmpty
        for (index, cardOnBoard) in game.cards[0..<cardBoardView.cardsOnBoard.count].enumerated() {
            let cardView = cardBoardView.cardsOnBoard[index]
            configure(cardView, with: cardOnBoard)
        }
        let newDealtCards = game.cards[cardBoardView.cardsOnBoard.count...]
        let newDealtCardViews = newDealtCards.reduce([CardView]()) {
            var copy = $0
            let cardView = CardView()
            configure(cardView, with: $1)
            copy.append(cardView)
            return copy
        }
        cardBoardView.add(newDealtCardViews)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
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
    
    // MARK: CardTapping impl
    @objc internal func cardTapped(_ gesture: UITapGestureRecognizer) {
        guard
            let tappedCard = gesture.view as? CardView,
            let indexTappedCard = cardBoardView.cardsOnBoard.firstIndex(of: tappedCard),
            indexTappedCard < game.cards.count
        else { return }

        game.chooseCard(withIndex: indexTappedCard)
    }
}
