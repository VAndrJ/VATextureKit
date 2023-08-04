//
//  NSObjectTests.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 02.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class NSObjectTests: XCTestCase {
    
    func test_function_wasOverrided() {
        let sut = TestOverrideChildClass()

        XCTAssertTrue(sut.overrides(#selector(TestOverrideClass.checkForOverrides)))
    }

    func test_function_wasNotOverrided() {
        let sut = TestNotOverrideChildClass()

        XCTAssertFalse(sut.overrides(#selector(TestNotOverrideClass.checkForOverrides)))
    }
}

private class TestOverrideClass: NSObject {

    @objc func checkForOverrides() {}
}

private class TestOverrideChildClass: TestOverrideClass {

    override func checkForOverrides() {
        print("overrided")
    }
}

private class TestNotOverrideClass: NSObject {

    @objc func checkForOverrides() {}
}

private class TestNotOverrideChildClass: TestNotOverrideClass {}
