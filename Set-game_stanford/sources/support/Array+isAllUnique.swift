//
//  Array+isAllUnique.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 25/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func isAllUnique() -> Bool {
        let convolution = self.reduce(Set<Element>()){ acc, el -> Set<Element> in
            var copy = acc
            copy.insert(el)
            return copy
        }
        
        return convolution.count == self.count
    }
}
