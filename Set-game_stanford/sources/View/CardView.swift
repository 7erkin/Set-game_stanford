//
//  CardView.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 14/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import UIKit

fileprivate struct CardViewSign {
    var figureColor: UIColor
    var filling: Filling
    var figure: Figure
    var figureCount: Int
}

class CardView: UIView {
    private var cardSign: CardViewSign! { didSet { setNeedsDisplay() } }
    var isChoosen = false { didSet { setNeedsDisplay() } }
    var isVisible = false { didSet { setNeedsDisplay() } }
    var isHint = false { didSet { setNeedsLayout() } }
    
    func applySigns(colorSign: Sign, fillingSign: Sign, figureSign: Sign, figureCountSign: Sign) {
        cardSign = CardViewSign(
            figureColor: colorSign.toColor(),
            filling: fillingSign.toFilling(),
            figure: figureSign.toFigure(),
            figureCount: figureCountSign.toFigureCount()
        )
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        subviews.forEach{ $0.removeFromSuperview() }
        if !isVisible {
            backgroundColor = .clear
            return
        }
        
        guard cardSign != nil else { fatalError("In \(#function): cardSign cannot be nil") }
            
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 5.0)
        // roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        if isHint {
            UIColor.blue.setStroke()
            roundedRect.lineWidth = 10.0
            roundedRect.stroke()
        }
        
        if isChoosen {
            UIColor.red.setStroke()
            roundedRect.lineWidth = 10.0
            roundedRect.stroke()
        }
        
        let figuresView = createFiguresView(
            color: cardSign.figureColor,
            filling: cardSign.filling,
            figure: cardSign.figure,
            figuresCount: 2
        )
        figuresView.draw(bounds)
    }
}

@objc enum Filling: Int {
    case solid
    case partial
    case empty
}

enum Figure {
    case rectangle
    case triangle
    case oval
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
