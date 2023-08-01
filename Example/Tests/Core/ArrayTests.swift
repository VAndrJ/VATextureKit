//
//  ArrayTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 01.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class ArrayTests: XCTestCase {

    func test_sum_withElement() {
        let value = 2
        let array = [0, 1, 10]
        let expectedArray = array.map { $0 + value }

        XCTAssertEqual(expectedArray, array + value)
    }
}
