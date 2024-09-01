//
//  VASizedViewWrapperNodeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 12.03.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import SnapshotTesting
import VATextureKit

class VASizedViewWrapperNodeTests: XCTestCase, MainActorIsolated {

    override func setUp() {
        appContext.themeManager.setLightAsCustomTheme()
    }

    func test_sizing_height() {
        let label = UILabel()
        label.text = "Test".dummyLong(repeating: 15)
        label.numberOfLines = 0
        let sut = VASizedViewWrapperNode(
            childGetter: { label },
            sizing: .viewHeight
        )

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_sizing_width() {
        let label = UILabel()
        label.text = "Test".dummyLong(repeating: 2)
        label.numberOfLines = 0
        let sut = VASizedViewWrapperNode(
            childGetter: { label },
            sizing: .viewWidth
        )

        assertNodeSnapshot(matching: sut, size: .freeWidthFixedHeight(100))
    }

    func test_sizing_size() {
        let label = UILabel()
        label.text = "Test".dummyLong(repeating: 2).dummyLong(separator: "\n", repeating: 3)
        label.numberOfLines = 0
        let sut = VASizedViewWrapperNode(
            childGetter: { label },
            sizing: .viewSize
        )

        assertNodeSnapshot(matching: sut, size: .auto)
    }
}
