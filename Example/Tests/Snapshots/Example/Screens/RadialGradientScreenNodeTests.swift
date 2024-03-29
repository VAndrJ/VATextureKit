//
//  RadialGradientScreenNodeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 06.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import SnapshotTesting
import VATextureKit

class RadialGradientScreenNodeTests: XCTestCase, MainActorIsolated {

    func test_node() {
        appContext.themeManager.setLightAsCustomTheme()
        let sut = RadialGradientScreenNode()

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(width: 24, height: 24 * 6)))
    }

    func test_node_dark_theme() {
        appContext.themeManager.setDarkAsCustomTheme()
        let sut = RadialGradientScreenNode()

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(width: 24, height: 24 * 6)))
    }
}
