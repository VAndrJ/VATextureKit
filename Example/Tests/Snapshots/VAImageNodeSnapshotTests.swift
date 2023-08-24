//
//  VAImageNodeSnapshotTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 24.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import SnapshotTesting
import VATextureKit

class VAImageNodeSnapshotTests: XCTestCase {

    func test_node() {
        appContext.themeManager.setLightAsCustomTheme()
        let sut = VAImageNode(
            image: R.image.chevron_right(),
            size: CGSize(same: 24),
            contentMode: .scaleAspectFill,
            tintColor: { $0.systemOrange },
            backgroundColor: { $0.secondarySystemBackground }
        )
        sut.displaysAsynchronously = false

        assertNodeSnapshot(matching: sut, size: .auto)
    }

    func test_node_dark_theme() {
        appContext.themeManager.setDarkAsCustomTheme()
        let sut = VAImageNode(
            image: R.image.chevron_right(),
            size: CGSize(same: 24),
            contentMode: .scaleAspectFill,
            tintColor: { $0.systemOrange },
            backgroundColor: { $0.secondarySystemBackground }
        )
        sut.displaysAsynchronously = false

        assertNodeSnapshot(matching: sut, size: .auto)
    }

    func test_node_tint_change() {
        appContext.themeManager.setLightAsCustomTheme()
        let sut = VAImageNode(
            image: R.image.chevron_right(),
            size: CGSize(same: 24),
            contentMode: .scaleAspectFill,
            tintColor: { $0.systemOrange },
            backgroundColor: { $0.secondarySystemBackground }
        )
        sut.tintColor = .green
        sut.displaysAsynchronously = false

        assertNodeSnapshot(matching: sut, size: .auto)
    }
}
