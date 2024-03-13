//
//  VAViewHostingNodeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 12.03.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import SnapshotTesting
import VATextureKit
import SwiftUI

class VAViewHostingNodeTests: XCTestCase, MainActorIsolated {

    override func setUp() {
        appContext.themeManager.setLightAsCustomTheme()
    }

    func test_sizing_height() {
        let sut = VAViewHostingNode(
            body: {
                HStack {
                    Text("Test")
                    Spacer()
                    Text("Test\nTest")
                }
            },
            sizing: .viewHeight
        )

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_sizing_width() {
        let sut = VAViewHostingNode(
            body: {
                VStack {
                    Text("Test")
                    Spacer()
                    Text("Test Test")
                }
            },
            sizing: .viewWidth
        )

        assertNodeSnapshot(matching: sut, size: .freeWidthFixedHeight(100))
    }

    func test_sizing_size() {
        let sut = VAViewHostingNode(
            body: {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Test Test")
                        Text("Test")
                    }
                    .background(.green)
                    VStack(alignment: .trailing) {
                        Text("Test")
                        Text("Test Test")
                    }
                    .background(.orange)
                }
            },
            sizing: .viewSize
        )

        assertNodeSnapshot(matching: sut, size: .auto)
    }
}
