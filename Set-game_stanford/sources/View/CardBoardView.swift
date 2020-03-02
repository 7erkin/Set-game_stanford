//
//  CardBoardView.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 22/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import UIKit

fileprivate var spacingBetweenCards = CGFloat(5.0)

@IBDesignable
class CardBoardView: UIStackView {
    private(set) var cardsOnBoard: [CardView] = [] {
        didSet {
            setNeedsLayout()
        }
        willSet {
            if newValue.isEmpty {
                self.cardsOnBoard.forEach{ $0.removeFromSuperview() }
                setNeedsLayout()
            }
        }
    }
    
    private var categorizedCardsIndices: ([Int], [Int], [Int]) {
        let categorizedCardsIndices = cardsOnBoard.indices.reduce(([Int](), [Int](), [Int]())){ acc, index in
            var copy = acc
            let card = cardsOnBoard[index]
            if cardsOnBoard[index].frame == CGRect.zero {
                /* new card */
                copy.1.append(index)
            } else {
                /* old card */
                copy.0.append(index)
                if card.isMatched {
                    /* matched card*/
                    copy.2.append(index)
                }
            }
            return copy
        }
        return categorizedCardsIndices
    }
    
    private var cardsTranslationUnit: [Int] = []
    
    private var cardFrames: [CGRect] {
        let cardsCount = cardsOnBoard.count
        
        let (rowsCount, columnsCount) = cardsToGrid[cardsCount]!
        
        let cardWidth = (bounds.width - CGFloat(columnsCount - 1) * spacingBetweenCards) / CGFloat(columnsCount)
        let cardHeight = (bounds.height - CGFloat(rowsCount - 1) * spacingBetweenCards) / CGFloat(rowsCount)
        return (0..<rowsCount).flatMap{ rowIndex in
            (0..<columnsCount).map{ columnIndex in
                CGRect(
                    x: CGFloat(columnIndex) * (cardWidth + spacingBetweenCards),
                    y: CGFloat(rowIndex) * (cardHeight + spacingBetweenCards),
                    width: cardWidth,
                    height: cardHeight
                )
            }
        }
    }
    
    private func configureCardViews() {
        let cardsShuffleGesture = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards))
        self.addGestureRecognizer(cardsShuffleGesture)
    }
    
    @objc private func onCardTapped(_ gesture: UITapGestureRecognizer) {
        cardTappingDelegate.cardTapped(gesture)
    }
    
    @objc private func shuffleCards(_ gesture: UIGestureRecognizer) {
        if gesture.state == .ended {
            cardsTranslationUnit.shuffle()
            setNeedsLayout()
        }
    }
    
    private func deal(cards: [CardView], on frames: [CGRect]) {
        assert(cards.count == frames.count, "cards.count must be equal frames.count")
        
        cards.forEachWithIndex{ card, index in
            card.frame.origin.y = bounds.height
            card.frame.origin.x = bounds.midX
            card.frame.size = CGSize(width: frames[index].width, height: frames[index].height)
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.5,
                delay: 0.1 * Double(index),
                options: [.curveEaseOut],
                animations: { card.frame = frames[index] },
                completion: { _ in
                    UIView.transition(
                        with: card,
                        duration: 0.5,
                        options: [.transitionFlipFromLeft],
                        animations: { card.isFaceUp = true },
                        completion: nil
                    )
                }
            )
        }
    }
    
    private func updatePosition(cards: [CardView], on frames: [CGRect]) {
        assert(cards.count == frames.count, "cards.count must be equal frames.count")
        
        cards.forEachWithIndex{ card, index in
            let index = cardsTranslationUnit[index]
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.5,
                delay: 0.0,
                options: [.allowUserInteraction],
                animations: { card.frame = frames[index] },
                completion: nil
            )
        }
    }
    
    private func removeMatchedCards(_ cards: [CardView]) {
        cards.forEach{ card in
            let relativeCardFrame = card.convert(card.bounds, to: removedCardPositionInformingDelegate.view)
            let destinationFrame = removedCardPositionInformingDelegate.removedCardPosition
            var transform = CGAffineTransform(translationX: 0, y: destinationFrame.origin.y - relativeCardFrame.origin.y)
            transform = transform.scaledBy(x: destinationFrame.width / relativeCardFrame.width, y: destinationFrame.height / relativeCardFrame.height)
            UIView.animate(
                withDuration: 5.0,
                animations: {
                    card.transform = transform
                },
                completion: {[weak self] _ in
                    card.transform = .identity
                    card.frame = CGRect.zero
                    card.isFaceUp = false
                    if card === cards.last! {
                        self?.matchedCardReplacingDelegate.replaceMatchedCards()
                    }
                }
            )
        }
    }
    
    var matchedCardReplacingDelegate: MatchedCardReplacing!
    var cardTappingDelegate: CardTapping!
    var removedCardPositionInformingDelegate: RemovedCardPositionInforming!
    
    func add(_ cardViews: [CardView]) {
        cardViews.forEach{
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onCardTapped(_:)))
            $0.addGestureRecognizer(tapGesture)
            addSubview($0)
        }
        cardsOnBoard.append(contentsOf: cardViews)
        cardsTranslationUnit.append(contentsOf: (cardsOnBoard.count - cardViews.count)..<cardsOnBoard.count)
    }
    
    func clean() {
        cardsOnBoard = []
        cardsTranslationUnit = []
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCardViews()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        configureCardViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard cardsOnBoard.count != 0 else { return }
        
        let (oldCardsIndices, newCardsIndices, matchedCardsIndices) = categorizedCardsIndices
        let oldCards = oldCardsIndices.map{ cardsOnBoard[$0] }
        let newCards = newCardsIndices.map{ cardsOnBoard[$0] }
        let matchedCards = matchedCardsIndices.map{ cardsOnBoard[$0] }
        
        var frames = cardFrames
        updatePosition(cards: oldCards, on: oldCardsIndices.map{ frames[$0] })
        removeMatchedCards(matchedCards)
        frames = newCardsIndices.map{ frames[$0] }
        deal(cards: newCards, on: frames)
    }
}
