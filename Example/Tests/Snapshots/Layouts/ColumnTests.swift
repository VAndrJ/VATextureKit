//
//  ColumnTests.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 17.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
import SnapshotTesting
import VATextureKit

@MainActor
class ColumnTests: XCTestCase {
    private let firstRectangleNode = ASDisplayNode()
        .sized(CGSize(same: 64))
        .apply {
            $0.backgroundColor = .orange
        }
    private let secondRectangleNode = ASDisplayNode()
        .sized(CGSize(same: 32))
        .apply {
            $0.backgroundColor = .cyan
        }

    func test_column_default() {
        let node = VADisplayNode()
        node.layoutSpecBlock = { [self] _, _ in
            Column {
                firstRectangleNode
                secondRectangleNode
            }
        }

        assertNodeSnapshot(matching: node, size: .auto)
    }

    func test_column_spacing() {
        let node = VADisplayNode()
        node.layoutSpecBlock = { [self] _, _ in
            Column(spacing: 8) {
                firstRectangleNode
                secondRectangleNode
            }
        }

        assertNodeSnapshot(matching: node, size: .auto)
    }

    func test_column_alignment_end() {
        let node = VADisplayNode()
        node.layoutSpecBlock = { [self] _, _ in
            Column(cross: .end) {
                firstRectangleNode
                secondRectangleNode
            }
        }

        assertNodeSnapshot(matching: node, size: .auto)
    }
}
