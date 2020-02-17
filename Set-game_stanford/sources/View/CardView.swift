//
//  CardView.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 14/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import UIKit

class CardView: UIView {
    private var figureColor: UIColor!
    private var filling: Filling!
    private var figure: Figure!
    private var figureCount: Int!
    
    func applySigns(colorSign: Sign, fillingSign: Sign, figureSign: Sign, figureCountSign: Sign) {
        figureColor = colorSign.toColor()
        filling = fillingSign.toFilling()
        figure = figureSign.toFigure()
        figureCount = figureCountSign.toFigureCount()
    }
    
    private lazy var figureStack: UIStackView = {
        let figureStack = UIStackView(arrangedSubviews: figures)
        figureStack.spacing = 20.0
        figureStack.axis = .vertical
        figureStack.alignment = .center
        addSubview(figureStack)
        return figureStack
    }()
    
    private lazy var figures: [UILabel] = {
        var figures: [NSAttributedString] = []
        let string = NSAttributedString(string: figure.rawValue, attributes: [
            NSAttributedString.Key.foregroundColor: figureColor
        ])
        
        for _ in 0..<figureCount {
            figures.append(string)
        }
        
        return figures.map{ let label = UILabel(); label.attributedText = $0; return label }
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        figureStack.center = CGPoint(x: bounds.midX, y: bounds.midY)
        figureStack.frame = frame
    }
}

fileprivate enum Filling {
    case solid
    case partial
    case empty
}

fileprivate enum Figure: String {
    case rectangle = "■"
    case triangle = "▲"
    case oval = "●"
}

extension Sign {
    fileprivate func toColor() -> UIColor {
        switch self {
            case .sign1:
                return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            case .sign2:
                return #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            case .sign3:
                return #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        }
    }
    
    fileprivate func toFilling() -> Filling {
        switch self {
            case .sign1:
                return .solid
            case .sign2:
                return .partial
            case .sign3:
                return .empty
        }
    }
    
    fileprivate func toFigure() -> Figure {
        switch self {
            case .sign1:
                return .rectangle
            case .sign2:
                return .triangle
            case .sign3:
                return .oval
        }
    }
    
    fileprivate func toFigureCount() -> Int {
        return Sign.all.firstIndex(of: self)! + 1
    }
}
