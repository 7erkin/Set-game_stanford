//
//  FIgureFilling.swift
//  Set-game_stanford
//
//  Created by user166334 on 2/26/20.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import Foundation
import UIKit

protocol FigureFilling {
    var color: UIColor! { get set }
    
    func fill(_ rect: CGRect, figurePath: UIBezierPath)
}

struct EmptyFilling: FigureFilling {
    var color: UIColor!
    
    func fill(_ rect: CGRect, figurePath: UIBezierPath) {}
}

struct PartialFilling: FigureFilling {
    private let spacingBeetwenStripes: CGFloat = 3
    var color: UIColor!
    
    func fill(_ rect: CGRect, figurePath: UIBezierPath) {
        let stripeLineCount = Int(rect.height / spacingBeetwenStripes)
        for i in 0...stripeLineCount {
            let stripePath = UIBezierPath()
            stripePath.move(to: CGPoint(x: 0, y: spacingBeetwenStripes * CGFloat(i)))
            stripePath.addLine(to: CGPoint(x: rect.width, y: spacingBeetwenStripes * CGFloat(i)))
            stripePath.stroke()
        }
    }
}

struct SolidFilling: FigureFilling {
    var color: UIColor!
    
    func fill(_ rect: CGRect, figurePath: UIBezierPath) {
        color.setFill()
        figurePath.fill()
    }
}

func createFilling(_ filling: Filling, withColor color: UIColor) -> FigureFilling {
    var figureFilling: FigureFilling = {
        switch filling {
            case .empty: return EmptyFilling()
            case .partial: return PartialFilling()
            case .solid: return SolidFilling()
        }
    }()
    figureFilling.color = color
    return figureFilling
}
