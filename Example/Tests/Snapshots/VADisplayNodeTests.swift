//
//  VADisplayNodeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 31.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
import SnapshotTesting
import VATextureKit

class VADisplayNodeTests: XCTestCase {

    func test_node_color() {
        let sut = VADisplayNode()
        sut.backgroundColor = .green

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 24)))
    }

    func test_node_layout() {
        let sut = VADisplayNode()
        sut.backgroundColor = .green
        let child1 = VADisplayNode()
        child1.backgroundColor = .orange
        let child2 = VADisplayNode()
        child2.backgroundColor = .cyan
        sut.layoutSpecBlock = { _, _ in
            Column(cross: .stretch) {
                Row {
                    child1
                        .ratio(1)
                }
                .flex(grow: 1)
                Row(main: .end) {
                    child2
                        .ratio(1)
                }
                .flex(grow: 1)
            }
        }

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 48)))
    }
}
