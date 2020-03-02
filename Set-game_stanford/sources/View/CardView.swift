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
    
    private lazy var hintedAnimator: UIViewPropertyAnimator = {
        let animator = UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.5,
            delay: 0.0,
            options: [.autoreverse, .repeat],
            animations: {},
            completion: nil
        )
        return animator
    }()
    
    private let backgroundImage: UIImage = {
        let image = UIImage(named: "stanford-logo")!
        let backgroundImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .up)
        return backgroundImage
    }()
    
    var isChoosen = false { didSet { setNeedsDisplay() } }
    var isHinted = false { didSet { setNeedsDisplay() } }
    var isFaceUp = false { didSet {
        setNeedsDisplay(); setNeedsLayout() } }
    var isMatched = false { didSet { setNeedsDisplay() } }
    
    private lazy var figuresView: FiguresView = {
        let figuresView = FiguresView()
        addSubview(figuresView)
        return figuresView
    }()
    
    func applySigns(colorSign: Sign, fillingSign: Sign, figureSign: Sign, figureCountSign: Sign) {
        figuresView.figuresDescription = FiguresDescription(
            figuresCount: figureCountSign.toFigureCount(),
            figure: figureSign.toFigure(),
            filling: fillingSign.toFilling(),
            color: colorSign.toColor()
        )
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        clearsContextBeforeDrawing = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        /* drawing card */
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 5.0)
        path.addClip()
        
        if !isFaceUp {
            backgroundImage.draw(in: bounds)
            return
        }
        
        UIColor.white.setFill()
        path.fill()
        
        if isHinted {
            UIColor.red.setFill()
            path.fill()
        } else {
            UIColor.white.setFill()
            path.fill()
        }
        
        /* drawing choosen card */
//        if isChoosen {
//            UIColor.black.setFill()
//            path.fill()
//        } else {
//            UIColor.white.setFill()
//            path.fill()
//        }
    }
    
    override func layoutSubviews() {
        figuresView.isHidden = !isFaceUp
        figuresView.frame = CGRect(x: margin, y: margin, width: bounds.width - 2 * margin, height: bounds.height - 2 * margin)
        figuresView.center = CGPoint(x: bounds.midX, y: bounds.midY)
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
