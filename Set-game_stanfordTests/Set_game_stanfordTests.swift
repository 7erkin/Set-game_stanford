//
//  Set_game_stanfordTests.swift
//  Set-game_stanfordTests
//
//  Created by Олег Черных on 25/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import XCTest

@testable import Set_game_stanford

class ArrayExtensionsTests: XCTestCase {
    func testIsAllUnique() {
        let testedData: [(array: [Int], expectedResult: Bool)] = [
            ([1,2,3,4,5], true),
            ([1,1,1,3,4], false),
            ([3,2,1,1,5], false),
            ([0,7,0], false),
            ([-1,2,-2,4,5], true)
        ]
        
        testedData.forEach{ XCTAssertEqual($0.array.isAllUnique(), $0.expectedResult) }
    }
}
