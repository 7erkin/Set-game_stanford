//
//  CardView.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 14/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import UIKit

class CardView: UIView {
    private let margin: CGFloat = 10
    
    var isChoosen = false { didSet {  } }
    var isVisible = false {
        didSet {
            self.backgroundColor = self.isVisible ? .white : .clear
        }
    }
    var isHint = false { didSet {  } }
    
    private lazy var figuresView: FiguresView = {
        let figuresView = FiguresView(frame: bounds)
        addSubview(figuresView)
        return figuresView
    }()
    
    func applySigns(colorSign: Sign, fillingSign: Sign, figureSign: Sign, figureCountSign: Sign) {
        figuresView.descr = Description(
            figuresCount: figureCountSign.toFigureCount(),
            figure: figureSign.toFigure(),
            filling: fillingSign.toFilling(),
            color: colorSign.toColor()
        )
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        figuresView.frame = CGRect(x: margin, y: margin, width: bounds.width - 2 * margin, height: bounds.height - 2 * margin)
    }
}

enum Filling: Int {
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
