//
//  ASSizeRangeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 01.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class ASSizeRangeTests: XCTestCase {

    func test_constant_unconstrained() {
        XCTAssertEqual(ASSizeRange.unconstrained, ASSizeRangeUnconstrained)
    }

    func test_constant_zero() {
        XCTAssertEqual(ASSizeRange.zero, ASSizeRangeZero)
    }

    func test_init_widthHeightRange() {
        let widthRange: ClosedRange<CGFloat> = 0.0...100.0
        let heightRange: ClosedRange<CGFloat> = 0.0...100.0

        XCTAssertEqual(
            ASSizeRange(width: widthRange, height: heightRange),
            ASSizeRange(
                min: CGSize(width: widthRange.lowerBound, height: heightRange.lowerBound),
                max: CGSize(width: widthRange.upperBound, height: heightRange.upperBound)
            )
        )
    }

    func test_init_widthRange() {
        let widthRange: ClosedRange<CGFloat> = 0.0...100.0
        let height = 100.0

        XCTAssertEqual(
            ASSizeRange(width: widthRange, height: height),
            ASSizeRange(
                min: CGSize(width: widthRange.lowerBound, height: height),
                max: CGSize(width: widthRange.upperBound, height: height)
            )
        )
    }

    func test_init_heightRange() {
        let width = 100.0
        let heightRange: ClosedRange<CGFloat> = 0.0...100.0

        XCTAssertEqual(
            ASSizeRange(width: width, height: heightRange),
            ASSizeRange(
                min: CGSize(width: width, height: heightRange.lowerBound),
                max: CGSize(width: width, height: heightRange.upperBound)
            )
        )
    }

    func test_init_widthHeight() {
        let width = 100.0
        let height = 100.0

        XCTAssertEqual(
            ASSizeRange(width: width, height: height),
            ASSizeRange(
                min: CGSize(width: width, height: height),
                max: CGSize(width: width, height: height)
            )
        )
    }
}
