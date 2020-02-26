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

class FiguresView: UIStackView {
    var descr: Description! {
        didSet {
            subviews.forEach{ $0.removeFromSuperview() }
            let figures: [FigureView] = (0..<self.descr.figuresCount).map{ _ in
                createFigureView(color: self.descr.color, filling: self.descr.filling, figure: self.descr.figure)
            }
            figures.forEach{ addArrangedSubview($0) }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .vertical
        alignment = .fill
        distribution = .fillEqually
        spacing = 10.0
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        return
    }
}
