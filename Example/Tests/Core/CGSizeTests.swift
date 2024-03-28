//
//  CGSizeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 01.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class CGSizeTests: XCTestCase {

    func test_multiply() {
        let value = 10.0
        let size = CGSize(same: 10)
        let expectedSize = CGSize(width: value * size.width, height: value * size.height)

        XCTAssertEqual(expectedSize, size * value)
    }

    func test_division() {
        let value = 10.0
        let size = CGSize(same: 10)
        let expectedSize = CGSize(width: size.width / value, height: size.height / value)

        XCTAssertEqual(expectedSize, size / value)
    }

    func test_sum() {
        let value = 10.0
        let size = CGSize(same: 10)
        let expectedSize = CGSize(width: value + size.width, height: value + size.height)

        XCTAssertEqual(expectedSize, size + value)
    }

    func test_sum_sizes() {
        let value = CGSize(same: 10)
        let size = CGSize(same: 10)
        let expectedSize = CGSize(width: value.width + size.width, height: value.height + size.height)

        XCTAssertEqual(expectedSize, size + value)
    }

    func test_substraction() {
        let value = 5.0
        let size = CGSize(same: 10)
        let expectedSize = CGSize(width: size.width - value, height: size.height - value)

        XCTAssertEqual(expectedSize, size - value)
    }

    func test_substraction_sizes() {
        let value = CGSize(same: 5)
        let size = CGSize(same: 10)
        let expectedSize = CGSize(width: size.width - value.width, height: size.height - value.height)

        XCTAssertEqual(expectedSize, size - value)
    }

    func test_insets() {
        let value = UIEdgeInsets(all: 10)
        let size = CGSize(same: 10)
        let expectedSize = CGSize(width: value.left + value.right + size.width, height: value.top + value.bottom + size.height)

        XCTAssertEqual(expectedSize, size.adding(insets: value))
    }

    func test_delta() {
        let value = 10.0
        let size = CGSize(same: 10)
        let expectedSize = CGSize(width: value + size.width, height: value + size.height)

        XCTAssertEqual(expectedSize, size.adding(width: value, height: value))
    }

    func test_boundingMultiplier_min() {
        let size = CGSize(same: 100)
        let size1 = CGSize(width: size.width * 2, height: size.height * 5)

        XCTAssertEqual(2, size.aspectMinBoundingMultiplier(for: size1))
    }

    func test_boundingMultiplier_max() {
        let size = CGSize(same: 100)
        let size1 = CGSize(width: size.width * 2, height: size.height * 5)

        XCTAssertEqual(5, size.aspectMaxBoundingMultiplier(for: size1))
    }

    func test_area() {
        let size1 = CGSize(same: 1)
        let size2 = CGSize(width: 2, height: 3)

        XCTAssertEqual(1, size1.area)
        XCTAssertEqual(6, size2.area)
    }

    func test_ratio() {
        let size1 = CGSize(same: 1)
        let size2 = CGSize(width: 2, height: 3)
        let size3 = CGSize(width: 2, height: 1)

        XCTAssertEqual(1, size1.ratio)
        XCTAssertEqual(2 / 3, size2.ratio)
        XCTAssertEqual(2, size3.ratio)
    }
}
