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
            image: .init(resource: .chevronRight),
            size: .init(same: 24),
            contentMode: .scaleAspectFill,
            tintColor: { $0.systemOrange },
            backgroundColor: { $0.secondarySystemBackground }
        )

        assertNodeSnapshot(matching: sut, size: .auto)
    }

    func test_node_dark_theme() {
        appContext.themeManager.setDarkAsCustomTheme()
        let sut = VAImageNode(
            image: .init(resource: .chevronRight),
            size: .init(same: 24),
            contentMode: .scaleAspectFill,
            tintColor: { $0.systemOrange },
            backgroundColor: { $0.secondarySystemBackground }
        )

        assertNodeSnapshot(matching: sut, size: .auto)
    }

    func test_node_tint_change() {
        appContext.themeManager.setLightAsCustomTheme()
        let sut = VAImageNode(
            image: .init(resource: .chevronRight),
            size: .init(same: 24),
            contentMode: .scaleAspectFill,
            tintColor: { $0.systemOrange },
            backgroundColor: { $0.secondarySystemBackground }
        )
        sut.tintColor = .green

        assertNodeSnapshot(matching: sut, size: .auto)
    }

    func test_node_corner_fixed() {
        appContext.themeManager.setLightAsCustomTheme()
        let sut = VAImageNode(
            image: .init(resource: .chevronRight),
            size: .init(same: 24),
            contentMode: .scaleAspectFill,
            tintColor: { $0.systemOrange },
            backgroundColor: { $0.secondarySystemBackground },
            corner: .init(radius: .fixed(8), maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        )

        assertNodeSnapshot(matching: sut, size: .auto, drawHierarchyInKeyWindow: true)
    }

    func test_node_corner_proportional() {
        appContext.themeManager.setLightAsCustomTheme()
        let sut = VAImageNode(
            image: .init(resource: .chevronRight),
            size: .init(same: 24),
            contentMode: .scaleAspectFill,
            tintColor: { $0.systemOrange },
            backgroundColor: { $0.secondarySystemBackground },
            corner: .init(radius: .proportional(percent: 25), curve: .continuous)
        )

        assertNodeSnapshot(matching: sut, size: .auto)
    }

    func test_node_corner_proportionalFull() {
        appContext.themeManager.setLightAsCustomTheme()
        let sut = VAImageNode(
            image: .init(resource: .chevronRight),
            size: .init(same: 24),
            contentMode: .scaleAspectFill,
            tintColor: { $0.systemOrange },
            backgroundColor: { $0.secondarySystemBackground },
            corner: .init(radius: .proportional(percent: 100), curve: .circular)
        )

        assertNodeSnapshot(matching: sut, size: .auto)
    }
}
