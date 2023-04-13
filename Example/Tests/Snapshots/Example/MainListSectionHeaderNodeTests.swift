//
//  MainListSectionHeaderNodeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 02.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import SnapshotTesting
import VATextureKit

@MainActor
class MainListSectionHeaderNodeTests: XCTestCase {

    func test_node_short_strings() {
        appContext.themeManager.setLightAsCustomTheme()
        let sut = MainListSectionHeaderNode(viewModel: .init(title: "Title"))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_long_strings() {
        appContext.themeManager.setLightAsCustomTheme()
        let sut = MainListSectionHeaderNode(viewModel: .init(title: "Title".dummyLong()))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_dark_theme() {
        appContext.themeManager.setDarkAsCustomTheme()
        let sut = MainListSectionHeaderNode(viewModel: .init(title: "Title"))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }
}
