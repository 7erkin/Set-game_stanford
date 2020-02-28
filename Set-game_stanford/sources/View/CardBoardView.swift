//
//  CardBoardView.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 22/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import UIKit

fileprivate var spacingBetweenCards = CGFloat(20.0)

@IBDesignable
class CardBoardView: UIStackView {
    private var addedCards: [CardView] = []
    
    private(set) var cardsOnBoard: [CardView] = []
    
    func add(_ cardView: CardView) {
        addedCards.append(cardView)
        addSubview(cardView)
    }
    
    var matchedCardReplacingDelegate: MatchedCardReplacing!
    
    private func calculateCardFrames() -> [CGRect] {
        let cardsCount = cardsOnBoard.count + addedCards.count
        /* define rows */
        var rowsCount = 0
        for i in (0..<cardsCount / 2).reversed() {
            if cardsCount % i == 0 {
                rowsCount = i
                break
            }
        }
        /* define columns */
        let columnsCount = cardsCount / rowsCount
        
        let cardWidth = bounds.width / CGFloat(columnsCount) - spacingBetweenCards / 2
        let cardHeight = bounds.height / CGFloat(rowsCount) - spacingBetweenCards / 2
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
    
    override func layoutSubviews() {
        guard cardsOnBoard.count != 0 || addedCards.count != 0 else { return }
        
        let frames = calculateCardFrames()
        let cardsOnBoardFrames = frames[0..<cardsOnBoard.count]
        let addedCardsFrames = frames[cardsOnBoard.count...]
        cardsOnBoard.forEachWithIndex{ card, index in
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 1.0,
                delay: 0.0,
                options: [],
                animations: { card.frame = cardsOnBoardFrames[index] },
                completion: nil
            )
        }
        addedCards.forEachWithIndex{ card, index in
            card.frame.origin.y = bounds.height
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 1.0,
                delay: 0.1 * Double(index),
                options: [.curveEaseOut],
                animations: { card.frame = addedCardsFrames[index] },
                completion: {[weak self] _ in
                    guard let self = self else { return }
                    self.cardsOnBoard = self.addedCards
                    self.addedCards = []
                    UIView.transition(
                        with: card,
                        duration: 0.75,
                        options: [.transitionFlipFromLeft],
                        animations: { card.isFaceUp = true },
                        completion: nil)
                }
            )
        }
    }
}
