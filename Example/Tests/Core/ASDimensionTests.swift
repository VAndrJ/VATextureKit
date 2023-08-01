//
//  ASDimensionTests.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 01.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class ASDimensionTests: XCTestCase {

    func test_constant_auto() {
        XCTAssertEqual(ASDimension.auto, ASDimensionAuto)
    }

    func test_create_points() {
        let value = 10.0
        XCTAssertEqual(ASDimension.points(value), ASDimension(unit: .points, value: value))
    }

    func test_create_fraction() {
        let value = 0.3
        XCTAssertEqual(ASDimension.fraction(value), ASDimension(unit: .fraction, value: value))
    }

    func test_create_fractionPercent() {
        let value = 30.0
        XCTAssertEqual(ASDimension.fraction(percent: value), ASDimension(unit: .fraction, value: value / 100))
    }
}
