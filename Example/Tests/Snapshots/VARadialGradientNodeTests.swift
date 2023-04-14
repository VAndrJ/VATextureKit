//
//  VARadialGradientNodeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 11.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
import SnapshotTesting
import VATextureKit

class VARadialGradientNodeTests: XCTestCase {

    func test_node_cusom() {
        let sut = VARadialGradientNode(gradient: .custom(
            startPoint: .init(x: 0.2, y: 0.2),
            endPoint: .init(x: 0.6, y: 0.6)
        ))
        sut.update(colors: (.green, 0), (.orange, 1))

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 24)))
    }

    func test_node_default() {
        [VARadialGradientNode.Gradient.centered, .bottomLeft, .bottomRight, .topLeft, .topRight].forEach {
            let sut = VARadialGradientNode(gradient: $0)
            sut.update(colors: (.green, 0), (.orange, 1))

            assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 24)), additions: "\($0)")
        }
    }
}
