//
//  MainListCellNodeTests.swift
//  VATextureKit_Example
//
//  Created by VAndrJ on 01.04.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import SnapshotTesting
import VATextureKit

class MainListCellNodeTests: XCTestCase {

    func test_node_short_strings() {
        appContext.themeManager.setLightAsCustomTheme()
        let sut = MainListCellNode(viewModel: MainListCellNodeViewModel(title: "Title", description: "Description", route: .alert))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(375))
    }

    func test_node_long_strings() {
        appContext.themeManager.setLightAsCustomTheme()
        let sut = MainListCellNode(viewModel: MainListCellNodeViewModel(title: "Title".dummyLong(), description: "Description".dummyLong(), route: .alert))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(375))
    }

    func test_node_dark_theme() {
        appContext.themeManager.setDarkAsCustomTheme()
        let sut = MainListCellNode(viewModel: MainListCellNodeViewModel(title: "Title", description: "Description", route: .alert))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(375))
    }
}
