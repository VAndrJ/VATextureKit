//
//  VAImageNodeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 24.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class VAImageNodeTests: XCTestCase {

    func test_tint() {
        let sut = VAImageNode()

        XCTAssertEqual(UIColor.clear, sut.tintColor)
        
        sut.tintColor = nil

        XCTAssertEqual(UIColor.clear, sut.tintColor)
    }
}
