//
//  VALinearGradientNodeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 05.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
import SnapshotTesting
import VATextureKit

class VALinearGradientNodeTests: XCTestCase {

    func test_node_vertical() {
        let sut = VALinearGradientNode(gradient: .vertical)
        sut.update(colors: (.green, 0), (.orange, 1))

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 24)))
    }

    func test_node_horizontal() {
        let sut = VALinearGradientNode(gradient: .horizontal)
        sut.update(colors: (.green, 0), (.orange, 1))

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 24)))
    }

    func test_node_diagonal() {
        VALinearGradientNode.Diagonal.allCases.forEach {
            let sut = VALinearGradientNode(gradient: .diagonal($0))
            sut.update(colors: (.green, 0), (.orange, 1))

            assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 24)))
        }
    }
}
