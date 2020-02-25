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

struct Card: Equatable, CustomStringConvertible {
    var description: String {
        return "\(signs)"
    }
    var signs: [Sign]
    var isMatched: Bool = false
    var isChoosen: Bool = false
    var isHint: Bool = false
    var identifier: Int
    
    init(signs: [Sign]) {
        self.signs = signs
        identifier = Card.getIdentifier()
    }
    
    private static var identifier = 0
    private static func getIdentifier() -> Int {
        let copy = identifier
        identifier += 1
        return copy
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension Array where Element == Card {
    func isMatched() -> Bool {
        let acc: [Set<Sign>] = {
            let descriptorsCount = self[0].signs.count
            var acc = [Set<Sign>]()
            for _ in 0..<descriptorsCount {
                acc.append(Set<Sign>())
            }
            return acc
        }()
        
        return self.reduce(acc){ result, card -> [Set<Sign>] in
            var copy = result
            for (index, sign) in card.signs.enumerated() {
                copy[index].insert(sign)
            }
            return copy
        }.allSatisfy{ $0.count != 2 }
    }
}

extension Array where Element == Int {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return true
    }
}

extension Array where Element == Card {
    @discardableResult
    func some3UniquePermutation(_ body: ([Int]) -> Bool) -> Bool {
        var uniqueIndices = Set<[Int]>()
        
        for i in 0..<self.count - 2 {
            for j in 1..<self.count - 1 {
                for k in 2..<self.count {
                    let indices = [i, j, k]
                    if indices.isAllUnique() && uniqueIndices.first(where: { $0.allSatisfy{ indices.contains($0) } }) == nil {
                        uniqueIndices.insert(indices)
                        if body(indices) {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
}
