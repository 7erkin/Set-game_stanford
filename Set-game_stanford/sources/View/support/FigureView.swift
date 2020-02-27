//
//  FigureView.swift
//  Set-game_stanford
//
//  Created by user166334 on 2/26/20.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import UIKit

class FigureView: UIView {
    var figureFilling: FigureFilling!
    var figureDrawing: FigureDrawing!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        figureDrawing.draw(path, in: rect)
        path.addClip()
        figureFilling.fill(rect, figurePath: path)
    }
}

func createFigureView(color: UIColor, filling: Filling, figure: Figure) -> FigureView {
    let figureView = FigureView()
    figureView.figureDrawing = createDrawing(figure, withColor: color)
    figureView.figureFilling = createFilling(filling, withColor: color)
    return figureView
}
