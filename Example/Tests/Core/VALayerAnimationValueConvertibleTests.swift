//
//  VALayerAnimationValueConvertibleTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 01.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class VALayerAnimationValueConvertibleTests: XCTestCase {
    
    func test_CGFloat_functions() {
        let value: CGFloat = 10
        let zero: CGFloat = 0

        XCTAssertTrue(value.getIsEqual(to: value))
        XCTAssertFalse(value.getIsEqual(to: nil))
        XCTAssertFalse(value.getIsEqual(to: zero))

        XCTAssertEqual(1.0, value.getProgressMultiplier(to: zero, current: value))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: value, current: value))
        XCTAssertEqual(1.0, value.getProgressMultiplier(to: zero, current: nil))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: zero))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: zero))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: CGPoint.zero, current: zero))
    }

    func test_CGPoint_functions() {
        let value = CGPoint(x: 10, y: 10)
        let zero = CGPoint.zero

        XCTAssertTrue(value.getIsEqual(to: value))
        XCTAssertFalse(value.getIsEqual(to: nil))
        XCTAssertFalse(value.getIsEqual(to: zero))

        XCTAssertEqual(1.0, value.getProgressMultiplier(to: zero, current: value))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: value, current: value))
        XCTAssertEqual(1.0, value.getProgressMultiplier(to: zero, current: nil))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: zero))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: zero))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: CGFloat.zero, current: zero))
    }

    func test_CGRect_functions() {
        let value = CGRect(x: 10, y: 10, width: 10, height: 10)
        let zero = CGRect.zero

        XCTAssertTrue(value.getIsEqual(to: value))
        XCTAssertFalse(value.getIsEqual(to: nil))
        XCTAssertFalse(value.getIsEqual(to: zero))

        XCTAssertEqual(1.0, value.getProgressMultiplier(to: zero, current: value))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: value, current: value))
        XCTAssertEqual(1.0, value.getProgressMultiplier(to: zero, current: nil))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: zero))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: zero))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: CGFloat.zero, current: zero))
    }

    func test_CGSize_functions() {
        let value = CGSize(width: 10, height: 10)
        let zero = CGSize.zero

        XCTAssertTrue(value.getIsEqual(to: value))
        XCTAssertFalse(value.getIsEqual(to: nil))
        XCTAssertFalse(value.getIsEqual(to: zero))

        XCTAssertEqual(1.0, value.getProgressMultiplier(to: zero, current: value))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: value, current: value))
        XCTAssertEqual(1.0, value.getProgressMultiplier(to: zero, current: nil))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: zero))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: zero))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: CGFloat.zero, current: zero))
    }

    func test_UIColor_functions() {
        let value = UIColor.white
        let zero = UIColor.clear

        XCTAssertTrue(value.getIsEqual(to: value))
        XCTAssertFalse(value.getIsEqual(to: nil))
        XCTAssertFalse(value.getIsEqual(to: zero))

        XCTAssertEqual(1.0, value.getProgressMultiplier(to: zero, current: value))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: value, current: value))
        XCTAssertEqual(1.0, value.getProgressMultiplier(to: zero, current: nil))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: zero))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: zero))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: CGFloat.zero, current: zero))
    }

    func test_CGPath_functions() {
        let value = UIBezierPath(rect: CGRect(x: 10, y: 10, width: 10, height: 10)).cgPath
        let zero = UIBezierPath().cgPath

        XCTAssertTrue(value.getIsEqual(to: value))
        XCTAssertFalse(value.getIsEqual(to: nil))
        XCTAssertFalse(value.getIsEqual(to: zero))

        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: value))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: value, current: value))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: nil))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: zero))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: zero))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: CGFloat.zero, current: zero))
    }

    func test_UIBezierPath_functions() {
        let value = UIBezierPath(rect: CGRect(x: 10, y: 10, width: 10, height: 10))
        let zero = UIBezierPath()

        XCTAssertTrue(value.getIsEqual(to: value))
        XCTAssertFalse(value.getIsEqual(to: nil))
        XCTAssertFalse(value.getIsEqual(to: zero))

        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: value))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: value, current: value))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: nil))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: zero))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: zero))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: CGFloat.zero, current: zero))
    }

    func test_Array_functions() {
        let value: [CGFloat] = [1, 1]
        let zero: [CGFloat] = []

        XCTAssertTrue(value.getIsEqual(to: value))
        XCTAssertFalse(value.getIsEqual(to: nil))
        XCTAssertFalse(value.getIsEqual(to: zero))

        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: value))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: value, current: value))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: nil))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: zero))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: zero, current: zero))
        XCTAssertEqual(0.0, value.getProgressMultiplier(to: CGFloat.zero, current: zero))
    }
}
