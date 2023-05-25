//
//  VATextNodeTests.swift
//  VATextureKit_Tests
//
//  Created by VAndrJ on 25.05.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import XCTest
import SnapshotTesting
import VATextureKit

class VATextNodeTests: XCTestCase {

    func test_node_short() {
        let sut = generateSUT(text: "Text")

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_long() {
        let sut = generateSUT()

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_kern_fixed() {
        let sut = generateSUT(kern: .fixed(-1))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_kern_relative() {
        let sut = generateSUT(kern: .relative(-10))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_kern_custom() {
        let sut = generateSUT(kern: .custom({ $0 * 0.05 }))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    private func generateSUT(text: String = "Text".dummyLong(range: 0...20), kern: VAKern? = nil) -> VATextNode {
        VATextNode(
            text: text,
            fontStyle: .headline,
            kern: kern,
            alignment: .left,
            truncationMode: .byTruncatingTail,
            maximumNumberOfLines: 2,
            themeColor: { $0.label }
        )
    }
}
