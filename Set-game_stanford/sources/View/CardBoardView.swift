//
//  CardBoardView.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 22/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import UIKit

fileprivate var cardRowCount = 6
fileprivate var cardCount = 24
fileprivate var spacingBetweenCards = CGFloat(10.0)

@IBDesignable
class CardBoardView: UIStackView {
    private(set) var cards: [CardView] = {
        return (0..<cardCount).map{ _ in CardView() }
    }()
    
    private lazy var cardRows: [UIStackView] = {
        let cardInRow = cardCount / cardRowCount
        
        return cards
            .chunked(into: cardInRow)
            .reduce([UIStackView]()){ container, chunk -> [UIStackView] in
                let cardRow = chunk.reduce(UIStackView()){ row, card -> UIStackView in
                    row.addArrangedSubview(card)
                    return row
                }
                cardRow.alignment = .fill
                cardRow.distribution = .fillEqually
                cardRow.spacing = spacingBetweenCards
                cardRow.axis = .horizontal
                return container + [cardRow]
            }
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if subviews.isEmpty {
            cardRows.forEach{ addArrangedSubview($0) }
            alignment = .fill
            distribution = .fillEqually
            axis = .vertical
            spacing = spacingBetweenCards
        }
    }
}
