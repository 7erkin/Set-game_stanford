//
//  FigureDrawing.swift
//  Set-game_stanford
//
//  Created by user166334 on 2/26/20.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import Foundation
import UIKit

fileprivate let lineWidth: CGFloat = 2.0
fileprivate let margin: CGFloat = 0.0

protocol FigureDrawing {
    var color: UIColor! { get set }
    
    func draw(_ path: UIBezierPath, in rect: CGRect)
}

struct OvalDrawing: FigureDrawing {
    var color: UIColor!
    
    func draw(_ path: UIBezierPath, in rect: CGRect) {
        path.addArc(
            withCenter: CGPoint(x: rect.midX, y: rect.midY),
            radius: CGFloat.minimum(rect.width, rect.height) / 2,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
        )
        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
    }
}

struct TriangleDrawing: FigureDrawing {
    var color: UIColor!
    
    func draw(_ path: UIBezierPath, in rect: CGRect) {
        path.move(to: CGPoint(x: rect.size.width / 2, y: margin))
        path.addLine(to: CGPoint(x: rect.size.width - margin, y: rect.size.height - margin))
        path.addLine(to: CGPoint(x: margin, y: rect.size.height - margin))
        path.close()
        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
    }
}

struct RectangleDrawing: FigureDrawing {
    var color: UIColor!
    
    func draw(_ path: UIBezierPath, in rect: CGRect) {
        path.move(to: CGPoint(x: margin, y: margin))
        path.addLine(to: CGPoint(x: rect.width - margin, y: margin))
        path.addLine(to: CGPoint(x: rect.width - margin, y: rect.height - margin))
        path.addLine(to: CGPoint(x: margin, y: rect.height - margin))
        path.close()
        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
    }
}

func createDrawing(_ figure: Figure, withColor color: UIColor) -> FigureDrawing {
    var figureDrawing: FigureDrawing = {
        switch figure {
            case .oval: return OvalDrawing()
            case .triangle: return TriangleDrawing()
            case .rectangle: return RectangleDrawing()
        }
    }()
    figureDrawing.color = color
    return figureDrawing
}
