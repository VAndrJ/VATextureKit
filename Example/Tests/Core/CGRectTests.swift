//
//  CGRectTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 01.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class CGRectTests: XCTestCase {

    func test_position() {
        let value = 10.0
        let rect = CGRect(x: value, y: value, width: value, height: value)

        XCTAssertEqual(CGPoint(x: rect.origin.x + rect.width / 2, y: rect.origin.y + rect.height / 2), rect.position)
    }
}
