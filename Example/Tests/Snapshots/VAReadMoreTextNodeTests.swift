//
//  VAReadMoreTextNodeTests.swift
//  VATextureKit_Tests
//
//  Created by VAndrJ on 22.04.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import XCTest
import SnapshotTesting
import VATextureKit

@MainActor
class VAReadMoreTextNodeTests: XCTestCase {

    func test_node_color() {
        let sut = VAReadMoreTextNode(
            text: "Text".dummyLong(separator: " ", range: 0...30),
            maximumNumberOfLines: 2,
            readMore: .init(
                text: "Read more",
                fontStyle: .headline,
                colorGetter: { $0.systemBlue }
            )
        )

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }
}