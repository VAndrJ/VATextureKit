//
//  ImageNumberCellNodeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 13.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import SnapshotTesting
import VATextureKit

class ImageNumberCellNodeTests: XCTestCase {

    func test_node() {
        appContext.themeManager.setLightAsCustomTheme()
        let sut = ImageNumberCellNode(viewModel: .init(number: 1))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(48))
    }

    func test_node_dark() {
        appContext.themeManager.setDarkAsCustomTheme()
        let sut = ImageNumberCellNode(viewModel: .init(number: 1))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(48))
    }
}
