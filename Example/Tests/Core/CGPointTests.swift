//
//  CGPointTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 03.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class CGPointTests: XCTestCase {

    func test_init_same() {
        let point = CGPoint(x: 5, y: 5)
        let expectedPoint = CGPoint(xy: 5)

        XCTAssertEqual(point, expectedPoint)
    }

    func test_sum() {
        let point = CGPoint(x: 5, y: 5)
        let point1 = CGPoint(x: 5, y: 5)
        let expectedPoint = CGPoint(x: point.x + point1.x, y: point.y + point1.y)

        XCTAssertEqual(expectedPoint, point + point1)
    }

    func test_sum_value() {
        let point = CGPoint(x: 5, y: 5)
        let value = 5.0
        let expectedPoint = CGPoint(x: point.x + value, y: point.y + value)

        XCTAssertEqual(expectedPoint, point + value)
    }

    func test_substraction() {
        let point = CGPoint(x: 5, y: 5)
        let point1 = CGPoint(x: 5, y: 5)
        let expectedPoint = CGPoint(x: point.x - point1.x, y: point.y - point1.y)

        XCTAssertEqual(expectedPoint, point - point1)
    }

    func test_substraction_value() {
        let point = CGPoint(x: 5, y: 5)
        let value = 5.0
        let expectedPoint = CGPoint(x: point.x - value, y: point.y - value)

        XCTAssertEqual(expectedPoint, point - value)
    }

    func test_multiply() {
        let point = CGPoint(x: 5, y: 5)
        let value = 5.0
        let expectedPoint = CGPoint(x: point.x * value, y: point.y * value)

        XCTAssertEqual(expectedPoint, point * value)
    }

    func test_division() {
        let point = CGPoint(x: 5, y: 5)
        let value = 5.0
        let expectedPoint = CGPoint(x: point.x / value, y: point.y / value)

        XCTAssertEqual(expectedPoint, point / value)
    }

    func test_distance() {
        let zeroPoint: CGPoint = .zero
        let horizontalAxisPoint = CGPoint(x: 1, y: 0)
        let verticalAxisPoint = CGPoint(x: 0, y: 1)
        let point = CGPoint(x: 1, y: 1)

        XCTAssertEqual(1.0, zeroPoint.distance(to: horizontalAxisPoint))
        XCTAssertEqual(1.0, zeroPoint.distance(to: verticalAxisPoint))
        XCTAssertEqual(sqrt(2), zeroPoint.distance(to: point))
    }
}
