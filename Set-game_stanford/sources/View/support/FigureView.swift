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
    
    override func draw(_ rect: CGRect) {
        let path = figureDrawing.draw(rect)
        path.addClip()
        // figureFilling.fill(figureRect, figurePath: path)
    }
}

func createFigureView(color: UIColor, filling: Filling, figure: Figure) -> FigureView {
    let figureView = FigureView()
    figureView.figureDrawing = createDrawing(figure, withColor: color)
    figureView.figureFilling = createFilling(filling, withColor: color)
    return figureView
}
