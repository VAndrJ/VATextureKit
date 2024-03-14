//
//  MainListCellNodeTests.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 01.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import SnapshotTesting
import VATextureKit

class MainListCellNodeTests: XCTestCase {

    func test_node_short_strings() {
        appContext.themeManager.setLightAsCustomTheme()
        let sut = MainListCellNode(viewModel: .init(title: "Title", description: "Description", destination: AlertNavigationIdentity()))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(375))
    }

    func test_node_long_strings() {
        appContext.themeManager.setLightAsCustomTheme()
        let sut = MainListCellNode(viewModel: .init(title: "Title".dummyLong(), description: "Description".dummyLong(), destination: AlertNavigationIdentity()))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(375))
    }

    func test_node_dark_theme() {
        appContext.themeManager.setDarkAsCustomTheme()
        let sut = MainListCellNode(viewModel: .init(title: "Title", description: "Description", destination: AlertNavigationIdentity()))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(375))
    }
}
