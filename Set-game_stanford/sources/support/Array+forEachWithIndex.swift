//
//  Array+forEachWithIndex.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 27/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import Foundation

extension Array {
    func forEachWithIndex(_ body: (Element, Int) -> Void) {
        for (index, element) in self.enumerated() {
            body(element, index)
        }
    }
}
