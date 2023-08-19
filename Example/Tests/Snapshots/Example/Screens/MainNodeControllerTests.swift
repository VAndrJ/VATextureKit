//
//  MainNodeControllerTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 19.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import SnapshotTesting
import VATextureKit

class MainNodeControllerTests: XCTestCase {

    func test_node() {
        appContext.themeManager.setLightAsCustomTheme()
        let sut = MainNodeController(viewModel: MainViewModel(navigator: .dummy))
        sut.node.loadForPreview()

        assertNodeSnapshot(matching: sut.contentNode, size: .fixed(CGSize(width: 300, height: 2500)))
    }

    func test_node_dark_theme() {
        appContext.themeManager.setDarkAsCustomTheme()
        let sut = MainNodeController(viewModel: MainViewModel(navigator: .dummy))
        sut.node.loadForPreview()

        assertNodeSnapshot(matching: sut.contentNode, size: .fixed(CGSize(width: 300, height: 2500)))
    }
}
