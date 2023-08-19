//
//  VALinkTextNodeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 13.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import SnapshotTesting
import VATextureKit

class VALinkTextNodeTests: XCTestCase {

    func test_node() {
        appContext.themeManager.setLightAsCustomTheme()
        let sut = VALinkTextNode(text: "Lorem ipsum, http://google.com lorem ipsum, http://google.com lorem ipsum.")

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }
}
