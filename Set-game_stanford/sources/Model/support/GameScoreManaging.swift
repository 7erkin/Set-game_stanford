//
//  GameMode.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 22/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import Foundation

enum PointChangingReason {
    case WrongSet
    case Deal3More
}

protocol GameScoreManaging: class {
    func addPoint()
    func removePoint(reason: PointChangingReason)
    func resetPoints()
}
