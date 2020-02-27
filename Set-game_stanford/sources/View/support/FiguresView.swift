//
//  FiguresView.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 26/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import UIKit

struct Description {
    var figuresCount: Int
    var figure: Figure
    var filling: Filling
    var color: UIColor
}

fileprivate let maxFigures = 3

class FiguresView: UIView {
    var descr: Description! {
        didSet {
            subviews.forEach{ $0.removeFromSuperview() }
            let figures: [FigureView] = (0..<self.descr.figuresCount).map{ _ in
                createFigureView(color: self.descr.color, filling: self.descr.filling, figure: self.descr.figure)
            }
            figures.forEach{ addSubview($0) }
        }
    }
    
    private var figureHeight: CGFloat {
        return (bounds.height / CGFloat(maxFigures)) - (spaceBetweenFigures / 2)
    }
    
    private var spaceBetweenFigures: CGFloat {
        return bounds.height * 0.15
    }
    
    override func layoutSubviews() {
        guard !subviews.isEmpty else { return}
        
        let figureHeight = self.figureHeight
        subviews.forEachWithIndex{ subview, index in
            subview.frame = CGRect(
                origin: CGPoint(
                    x: 0,
                    y: (figureHeight + spaceBetweenFigures) * CGFloat(index)
                ),
                size: CGSize(
                    width: figureHeight,
                    height: figureHeight
                )
            )
            subview.center.x = bounds.midX
        }
        let subviewsFrameHeight = subviews.last!.frame.origin.y + subviews.last!.frame.size.height
        let shiftY = (bounds.height - subviewsFrameHeight) / 2
        subviews.forEach{ $0.frame.origin.y += shiftY }
    }
}
