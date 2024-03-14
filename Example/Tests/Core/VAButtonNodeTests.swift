//
//  VAButtonNodeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 23.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class VAButtonNodeTests: XCTestCase, MainActorIsolated {
    var sut: VAButtonNode!

    override func setUp() {
        sut = VAButtonNode()
        sut.loadForPreview()
    }

    override func tearDown() {
        sut = nil
    }

    func test_onTap_closure() {
        let receiver = MockTapReceiver()
        sut.onTap = { [weak receiver] in
            receiver?.isTapped = true
        }
        sut.sendActions(forControlEvents: .touchUpInside, with: nil)

        XCTAssertTrue(receiver.isTapped)
    }

    func test_onTap_funcWeakify() {
        let receiver = MockTapReceiver()
        sut.onTap(weakify: receiver) {
            $0.isTapped = true
        }
        sut.sendActions(forControlEvents: .touchUpInside, with: nil)

        XCTAssertTrue(receiver.isTapped)
    }

    func test_onTap_funcWeakifyTwoParameters() {
        let receiver = MockTapReceiver()
        let receiver1 = MockTapReceiver()
        sut.onTap(weakify: (receiver, receiver1)) {
            $0.isTapped = true
            $1.isTapped = true
        }
        sut.sendActions(forControlEvents: .touchUpInside, with: nil)

        XCTAssertTrue(receiver.isTapped)
        XCTAssertTrue(receiver1.isTapped)
    }
}
