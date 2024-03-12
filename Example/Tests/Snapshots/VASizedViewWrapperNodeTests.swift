//
//  VASizedViewWrapperNodeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 12.03.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import XCTest
import SnapshotTesting
import VATextureKit

@MainActor
class VASizedViewWrapperNodeTests: XCTestCase {

    override func setUp() {
        appContext.themeManager.setLightAsCustomTheme()
    }

    func test_sizing_height() {
        let label = UILabel()
        label.text = "Test".dummyLong(range: 0...14)
        label.numberOfLines = 0
        let sut = VASizedViewWrapperNode(
            actorChildGetter: { label },
            sizing: .viewHeight
        )

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_sizing_width() {
        let label = UILabel()
        label.text = "Test".dummyLong(range: 0...1)
        label.numberOfLines = 0
        let sut = VASizedViewWrapperNode(
            actorChildGetter: { label },
            sizing: .viewWidth
        )

        assertNodeSnapshot(matching: sut, size: .freeWidthFixedHeight(100))
    }

    func test_sizing_size() {
        let label = UILabel()
        label.text = "Test".dummyLong(range: 0...1).dummyLong(separator: "\n", range: 0...2)
        label.numberOfLines = 0
        let sut = VASizedViewWrapperNode(
            actorChildGetter: { label },
            sizing: .viewSize
        )

        assertNodeSnapshot(matching: sut, size: .auto)
    }
}
