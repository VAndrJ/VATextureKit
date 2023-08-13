//
//  TagCellNodeTests.swift
//  VATextureKit_Tests
//
//  Created by VAndrJ on 12.08.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import SnapshotTesting
import VATextureKit

class TagCellNodeTestsTests: XCTestCase {

    func test_node() {
        appContext.themeManager.setLightAsCustomTheme()
        let sut = TagCellNode(viewModel: .init(title: "Test"))

        assertNodeSnapshot(matching: sut, size: .auto)
    }

    func test_node_dark_theme() {
        appContext.themeManager.setDarkAsCustomTheme()
        let sut = TagCellNode(viewModel: .init(title: "Test"))

        assertNodeSnapshot(matching: sut, size: .auto)
    }
}
