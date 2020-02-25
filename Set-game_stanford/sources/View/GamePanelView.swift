//
//  GamePanelView.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 25/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import UIKit

@IBDesignable
class GamePanelView: UIStackView {
    @IBInspectable
    var setsOnBoardCount: Int = 0 {
        didSet {
            hintButton.setTitle("\(String(describing: self.setsOnBoardCount)) sets", for: UIControl.State.normal)
        }
    }
    
    @IBInspectable
    var isDeal3MoreButtonEnable: Bool = true {
        didSet {
            self.deal3MoreCardsButton.isEnabled = self.isDeal3MoreButtonEnable
        }
    }
    
    private(set) var hintButton: UIButton = {
        let button = UIButton()
        return UIButton()
    }()
    
    private(set) var newGameButton: UIButton = {
        let button = UIButton()
        button.setTitle("New game", for: UIControl.State.normal)
        return button
    }()
    
    private(set) var deal3MoreCardsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Deal 3+", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 20.0)
        return button
    }()
    
    private lazy var panelButtons: [UIButton] = {
        return [self.hintButton, self.newGameButton, self.deal3MoreCardsButton]
    }()
    
    private func configureButtons() {
        panelButtons.forEach{ button in
            button.backgroundColor = .green
        }
    }
    
    override func layoutSubviews() {
        if subviews.isEmpty {
            configureButtons()
            panelButtons.forEach{ addArrangedSubview($0) }
            alignment = .fill
            distribution = .fillEqually
            axis = .horizontal
            spacing = 10.0
        }
    }
}
