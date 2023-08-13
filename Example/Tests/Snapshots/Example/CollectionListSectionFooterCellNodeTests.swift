//
//  CollectionListSectionFooterCellNodeTests.swift
//  VATextureKit_Tests
//
//  Created by VAndrJ on 13.08.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import SnapshotTesting
import VATextureKit

class CollectionListSectionFooterCellNodeTests: XCTestCase {

    func test_node() {
        appContext.themeManager.setLightAsCustomTheme()
        let sut = CollectionListSectionFooterCellNode(viewModel: .init(title: "Test"))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_dark_theme() {
        appContext.themeManager.setDarkAsCustomTheme()
        let sut = CollectionListSectionFooterCellNode(viewModel: .init(title: "Test"))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }
}
