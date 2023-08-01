//
//  ASScrollDirectionTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 01.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class ASScrollDirectionTests: XCTestCase {

    func test_constant_vertical() {
        XCTAssertEqual(ASScrollDirection.vertical, ASScrollDirectionVerticalDirections)
    }

    func test_constant_horizontal() {
        XCTAssertEqual(ASScrollDirection.horizontal, ASScrollDirectionHorizontalDirections)
    }
}
