//
//  ColumnLayoutScreenNodeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 06.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import SnapshotTesting
import VATextureKit

@MainActor
class ColumnLayoutScreenNodeTests: XCTestCase {

    func test_node() {
        appContext.themeManager.setLightAsCustomTheme()
        let sut = ColumnLayoutScreenNode()

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(375))
    }

    func test_node_dark_theme() {
        appContext.themeManager.setDarkAsCustomTheme()
        let sut = ColumnLayoutScreenNode()

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(375))
    }
}
