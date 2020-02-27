//
//  Array+chunked.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 27/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
