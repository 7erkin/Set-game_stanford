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
    private(set) var cardsOnBoard: [CardView] = []
    private var cardsTranslationUnit: [Int] = []
    
    func add(_ cardViews: [CardView]) {
        cardViews.forEach{
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onCardTapped(_:)))
            $0.addGestureRecognizer(tapGesture)
            addSubview($0)
        }
        cardsOnBoard.append(contentsOf: cardViews)
        cardsTranslationUnit.append(contentsOf: (cardsOnBoard.count - cardViews.count)..<cardsOnBoard.count)
    }
    
    var matchedCardReplacingDelegate: MatchedCardReplacing!
    var cardTappingDelegate: CardTapping!
    
    @objc private func onCardTapped(_ gesture: UITapGestureRecognizer) {
        cardTappingDelegate.cardTapped(gesture)
    }
    
    private func calculateCardFrames() -> [CGRect] {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        let cardsShuffleGesture = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards))
        self.addGestureRecognizer(cardsShuffleGesture)
    }
    
    @objc private func shuffleCards(_ gesture: UIGestureRecognizer) {
        if gesture.state == .ended {
            cardsTranslationUnit.shuffle()
            setNeedsLayout()
        }
    }
    
    /* Q: called many times first time */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard cardsOnBoard.count != 0 else { return }
        
        let (oldCards, newCards) = cardsOnBoard.reduce(([CardView](), [CardView]())){ acc, el in
            var copy = acc
            if el.frame == CGRect.zero {
                copy.1.append(el)
            } else {
                copy.0.append(el)
            }
            return copy
        }
        
        var frames = calculateCardFrames()
        /* Must be set proper options */
        oldCards.forEachWithIndex{ card, index in
            let index = cardsTranslationUnit[index]
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.5,
                delay: 0.0,
                options: [.allowUserInteraction],
                animations: { card.frame = frames[index] },
                completion: nil
            )
        }
        frames = Array(frames[oldCards.count...])
        newCards.forEachWithIndex{ card, index in
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
}
