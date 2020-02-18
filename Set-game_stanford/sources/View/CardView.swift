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
    private var cardSign: CardViewSign! {
        didSet { setNeedsDisplay() }
    }
    
    var isChoosen = false {
        didSet { setNeedsDisplay() }
    }
    
    var isVisible = false {
        didSet { setNeedsDisplay() }
    }
    
    private var figureStack: UIStackView {
        let figureStack = UIStackView(arrangedSubviews: figures)
        figureStack.spacing = 20.0
        figureStack.axis = .vertical
        figureStack.alignment = .center
        addSubview(figureStack)
        return figureStack
    }
    
    private var figures: [UILabel] {
        var figures: [NSAttributedString] = []
        let attributedString = createAttributedString()
        
        for _ in 0..<cardSign.figureCount {
            figures.append(attributedString)
        }
        
        return figures.map{ let label = UILabel(); label.attributedText = $0; return label }
    }
    
    private func createAttributedString() -> NSAttributedString {
        var attributes: [NSAttributedString.Key:Any] = [:]
        switch cardSign.filling {
            case .empty:
                attributes[NSAttributedString.Key.strokeWidth] = 10
                attributes[NSAttributedString.Key.strokeColor] = cardSign.figureColor
            case .partial:
                attributes[NSAttributedString.Key.foregroundColor] = cardSign.figureColor.withAlphaComponent(0.5)
            case .solid:
                attributes[NSAttributedString.Key.foregroundColor] = cardSign.figureColor
        }
        let string = NSAttributedString(string: cardSign.figure.rawValue, attributes: attributes)
        return string
    }
    
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
            return
        }
        
        guard cardSign != nil else { fatalError("In \(#function): cardSign cannot be nil") }
            
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 5.0)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        if isChoosen {
            UIColor.red.setStroke()
            roundedRect.lineWidth = 10.0
            roundedRect.stroke()
        }
            
        figureStack.draw(bounds)
        figureStack.frame = bounds
            
        return
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
