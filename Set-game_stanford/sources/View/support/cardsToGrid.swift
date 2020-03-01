//
//  CardBoardGrid.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 01/03/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import Foundation

let cardsToGrid: [Int:(Int, Int)] = {
    var cardsToGrid = [
        12: (4, 3),
        15: (5, 4),
        18: (5, 4),
        21: (5, 5),
        24: (6, 5),
        27: (6, 5),
        30: (6, 5),
        33: (7, 6),
        36: (7, 6),
        39: (7, 6),
        42: (7, 6)
    ]
    (42...81).forEach{ cardsToGrid[$0] = (9, 9) }
    return cardsToGrid
}()
