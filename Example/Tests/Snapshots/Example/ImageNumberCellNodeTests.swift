//
//  ImageNumberCellNodeTests.swift
//  VATextureKit_Tests
//
//  Created by VAndrJ on 13.08.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
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
}
