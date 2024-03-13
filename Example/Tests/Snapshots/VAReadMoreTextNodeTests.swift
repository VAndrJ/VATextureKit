//
//  VAReadMoreTextNodeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 22.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
import SnapshotTesting
import VATextureKit

class VAReadMoreTextNodeTests: XCTestCase {

    override func setUp() {
        appContext.themeManager.setLightAsCustomTheme()
    }

    func test_node_color() {
        let sut = VAReadMoreTextNode(
            text: "Text".dummyLong(separator: " ", repeating: 31),
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
