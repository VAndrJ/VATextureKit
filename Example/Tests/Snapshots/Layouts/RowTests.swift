//
//  RowTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 17.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
import SnapshotTesting
import VATextureKit

@MainActor
class RowTests: XCTestCase {
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

    func test_row_default() {
        let node = VADisplayNode()
        node.layoutSpecBlock = { [self] _, _ in
            Row {
                firstRectangleNode
                secondRectangleNode
            }
        }

        assertNodeSnapshot(matching: node, size: .auto)
    }

    func test_row_spacing() {
        let node = VADisplayNode()
        node.layoutSpecBlock = { [self] _, _ in
            Row(spacing: 4) {
                firstRectangleNode
                secondRectangleNode
            }
        }

        assertNodeSnapshot(matching: node, size: .auto)
    }

    func test_row_alignment_end() {
        let node = VADisplayNode()
        node.layoutSpecBlock = { [self] _, _ in
            Row(cross: .end) {
                firstRectangleNode
                secondRectangleNode
            }
        }

        assertNodeSnapshot(matching: node, size: .auto)
    }

    func test_row_wrap() {
        let node = VADisplayNode()
        node.layoutSpecBlock = { [self] _, _ in
            Row(wrap: .wrap, line: 4) {
                firstRectangleNode
                secondRectangleNode
            }
            .maxConstrained(width: 64)
        }

        assertNodeSnapshot(matching: node, size: .auto)
    }
}
