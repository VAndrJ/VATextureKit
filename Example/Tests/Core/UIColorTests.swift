//
//  UIColorTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 03.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class UIColorTests: XCTestCase {

    func test_opaque() {
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let expectedColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)

        XCTAssertEqual(expectedColor, UIColor.fromAlpha(foreground: color))
    }
}
