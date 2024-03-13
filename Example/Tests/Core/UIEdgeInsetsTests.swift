//
//  UIEdgeInsetsTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 01.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class UIEdgeInsetsTests: XCTestCase {

    func test_origin() {
        let insets = UIEdgeInsets(all: 10)
        let expectedPoint = CGPoint(x: insets.left, y: insets.top)
        
        XCTAssertEqual(expectedPoint, insets.origin)
    }

    func test_vertical() {
        let insets = UIEdgeInsets(all: 10)
        let expectedValue = insets.top + insets.bottom

        XCTAssertEqual(expectedValue, insets.vertical)
    }

    func test_horizontal() {
        let insets = UIEdgeInsets(all: 10)
        let expectedValue = insets.left + insets.right

        XCTAssertEqual(expectedValue, insets.horizontal)
    }

    func test_init_all() {
        let value = 10.0
        let insets = UIEdgeInsets(all: value)
        let expectedInsets = UIEdgeInsets(top: value, left: value, bottom: value, right: value)

        XCTAssertEqual(expectedInsets, insets)
    }

    func test_init_vertical() {
        let value = 10.0
        let insets = UIEdgeInsets(vertical: value)
        let expectedInsets = UIEdgeInsets(top: value, left: 0, bottom: value, right: 0)

        XCTAssertEqual(expectedInsets, insets)
    }

    func test_init_horizontal() {
        let value = 10.0
        let insets = UIEdgeInsets(horizontal: value)
        let expectedInsets = UIEdgeInsets(top: 0, left: value, bottom: 0, right: value)

        XCTAssertEqual(expectedInsets, insets)
    }

    func test_init_axes() {
        let value = 10.0
        let insets = UIEdgeInsets(vertical: value, horizontal: value)
        let expectedInsets = UIEdgeInsets(top: value, left: value, bottom: value, right: value)

        XCTAssertEqual(expectedInsets, insets)
    }

    func test_init_top() {
        let value = 10.0
        let insets = UIEdgeInsets(top: value)
        let expectedInsets = UIEdgeInsets(top: value, left: 0, bottom: 0, right: 0)

        XCTAssertEqual(expectedInsets, insets)
    }

    func test_init_left() {
        let value = 10.0
        let insets = UIEdgeInsets(left: value)
        let expectedInsets = UIEdgeInsets(top: 0, left: value, bottom: 0, right: 0)

        XCTAssertEqual(expectedInsets, insets)
    }

    func test_init_bottom() {
        let value = 10.0
        let insets = UIEdgeInsets(bottom: value)
        let expectedInsets = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)

        XCTAssertEqual(expectedInsets, insets)
    }

    func test_init_right() {
        let value = 10.0
        let insets = UIEdgeInsets(right: value)
        let expectedInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: value)

        XCTAssertEqual(expectedInsets, insets)
    }

    func test_init_topBottom() {
        let value = 10.0
        let insets = UIEdgeInsets(top: value, bottom: value)
        let expectedInsets = UIEdgeInsets(top: value, left: 0, bottom: value, right: 0)

        XCTAssertEqual(expectedInsets, insets)
    }

    func test_init_leftRight() {
        let value = 10.0
        let insets = UIEdgeInsets(left: value, right: value)
        let expectedInsets = UIEdgeInsets(top: 0, left: value, bottom: 0, right: value)

        XCTAssertEqual(expectedInsets, insets)
    }

    func test_paddings() {
        let value = 10.0
        XCTAssertEqual(UIEdgeInsets(top: value), UIEdgeInsets(paddings: [.top(value)]))
        XCTAssertEqual(UIEdgeInsets(left: value), UIEdgeInsets(paddings: [.left(value)]))
        XCTAssertEqual(UIEdgeInsets(bottom: value), UIEdgeInsets(paddings: [.bottom(value)]))
        XCTAssertEqual(UIEdgeInsets(right: value), UIEdgeInsets(paddings: [.right(value)]))
        XCTAssertEqual(UIEdgeInsets(vertical: value), UIEdgeInsets(paddings: [.vertical(value)]))
        XCTAssertEqual(UIEdgeInsets(horizontal: value), UIEdgeInsets(paddings: [.horizontal(value)]))
        XCTAssertEqual(
            UIEdgeInsets(top: value, left: value, bottom: 0, right: 0),
            UIEdgeInsets(paddings: [.topLeft(value)])
        )
        XCTAssertEqual(
            UIEdgeInsets(top: 0, left: value, bottom: value, right: 0),
            UIEdgeInsets(paddings: [.bottomLeft(value)])
        )
        XCTAssertEqual(
            UIEdgeInsets(top: value, left: 0, bottom: 0, right: value),
            UIEdgeInsets(paddings: [.topRight(value)])
        )
        XCTAssertEqual(
            UIEdgeInsets(top: 0, left: 0, bottom: value, right: value),
            UIEdgeInsets(paddings: [.bottomRight(value)])
        )
        XCTAssertEqual(
            UIEdgeInsets(all: value),
            UIEdgeInsets(paddings: [.custom(top: value, left: value, bottom: value, right: value)])
        )
        XCTAssertEqual(
            UIEdgeInsets(all: value),
            UIEdgeInsets(paddings: [.insets(UIEdgeInsets(all: value))])
        )
        XCTAssertEqual(
            UIEdgeInsets(all: value),
            UIEdgeInsets(paddings: [.all(value)])
        )
    }
}
