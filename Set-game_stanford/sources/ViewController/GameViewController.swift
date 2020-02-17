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
    
    private lazy var cards: [CardView] = {
        return cardRows.reduce([UIView](), { $0 + $1.subviews }).map{ $0 as! CardView }
    }()
    
    private var game: Game = Game(initialCardCount: 12)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (index, card) in cards.enumerated() {
            if index < game.cards.count {
                let signs = game.cards[index].signs
                card.applySigns(colorSign: signs[0], fillingSign: signs[1], figureSign: signs[2], figureCountSign: signs[3])
            } else {
                card.isHidden = true
            }
        }
    }
}

