//
//  StackTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 17.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
import SnapshotTesting
import VATextureKit

@MainActor
class StackTests: XCTestCase {
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

    func test_stack_default() {
        let node = VADisplayNode()
        node.layoutSpecBlock = { [self] _, _ in
            Stack {
                firstRectangleNode
                secondRectangleNode
            }
        }

        assertNodeSnapshot(matching: node, size: .auto)
    }

    func test_stack_centered() {
        let node = VADisplayNode()
        node.layoutSpecBlock = { [self] _, _ in
            Stack {
                firstRectangleNode
                secondRectangleNode
                    .centered()
            }
        }

        assertNodeSnapshot(matching: node, size: .auto)
    }

    func test_stack_relatively() {
        let node = VADisplayNode()
        node.layoutSpecBlock = { [self] _, _ in
            Row(cross: .end) {
                firstRectangleNode
                secondRectangleNode
                    .relatively(horizontal: .end, vertical: .end)
            }
        }

        assertNodeSnapshot(matching: node, size: .auto)
    }
}
