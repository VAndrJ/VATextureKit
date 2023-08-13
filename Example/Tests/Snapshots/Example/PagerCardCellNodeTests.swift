//
//  PagerCardCellNodeTests.swift
//  VATextureKit_Tests
//
//  Created by VAndrJ on 13.08.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import SnapshotTesting
import VATextureKit

class PagerCardCellNodeTests: XCTestCase {

    func test_node() {
        appContext.themeManager.setLightAsCustomTheme()
        let sut = PagerCardCellNode(viewModel: .init(title: "Title", description: "Description"))

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 100)))
    }

    func test_node_dark_theme() {
        appContext.themeManager.setDarkAsCustomTheme()
        let sut = PagerCardCellNode(viewModel: .init(title: "Title", description: "Description"))

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 100)))
    }
}
