//
//  Card.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 13/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import Foundation

enum Sign {
    case sign1
    case sign2
    case sign3
    
    static var all: [Sign] {
        return [sign1, sign2, sign3]
    }
}

struct Card {
    var signs: [Sign]
    var isMatched: Bool = false
    var isChoosen: Bool = false
}

extension Array where Element == Card {
    func isMatched() -> Bool {
        if self.isEmpty { return false }
        
        let acc: [Set<Sign>] = {
            let descriptorsCount = self[0].signs.count
            var acc = [Set<Sign>]()
            acc.reserveCapacity(descriptorsCount)
            return acc
        }()
        
        return self.reduce(acc){ result, card -> [Set<Sign>] in
            var copy = result
            for (index, sign) in card.signs.enumerated() {
                copy[index].insert(sign)
            }
            return result
        }.allSatisfy{ $0.count != 2 }
    }
}
