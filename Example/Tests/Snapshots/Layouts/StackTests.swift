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

class StackTests: XCTestCase {
    private let firstRectangleNode = ASDisplayNode()
        .sized(CGSize(same: 64))
        .apply { $0.backgroundColor = .orange }
    private let secondRectangleNode = ASDisplayNode()
        .sized(CGSize(same: 32))
        .apply { $0.backgroundColor = .cyan }

    func test_stack_default() {
        let sut = VADisplayNode()
        sut.layoutSpecBlock = { [self] _, _ in
            Stack {
                firstRectangleNode
                secondRectangleNode
            }
        }

        assertNodeSnapshot(matching: sut, size: .auto)
    }

    func test_stack_centered() {
        let sut = VADisplayNode()
        sut.layoutSpecBlock = { [self] _, _ in
            Stack {
                firstRectangleNode
                secondRectangleNode
                    .centered()
            }
        }

        assertNodeSnapshot(matching: sut, size: .auto)
    }

    func test_stack_centeredX() {
        let sut = VADisplayNode()
        sut.layoutSpecBlock = { [self] _, _ in
            Stack {
                firstRectangleNode
                secondRectangleNode
                    .centered(.X)
            }
        }

        assertNodeSnapshot(matching: sut, size: .auto)
    }

    func test_stack_centeredY() {
        let sut = VADisplayNode()
        sut.layoutSpecBlock = { [self] _, _ in
            Stack {
                firstRectangleNode
                secondRectangleNode
                    .centered(.Y)
            }
        }

        assertNodeSnapshot(matching: sut, size: .auto)
    }

    func test_stack_relatively() {
        let sut = VADisplayNode()
        sut.layoutSpecBlock = { [self] _, _ in
            Stack {
                firstRectangleNode
                secondRectangleNode
                    .relatively(horizontal: .end, vertical: .end)
            }
        }

        assertNodeSnapshot(matching: sut, size: .auto)
    }

    func test_stack_minNodesSize() {
        let firstRectangleNode = ASDisplayNode()
            .minConstrained(width: 24, height: 48)
            .apply { $0.backgroundColor = .orange }
        let secondRectangleNode = ASDisplayNode()
            .minConstrained(width: 48, height: 24)
            .maxConstrained(width: 48, height: 36)
            .apply { $0.backgroundColor = .cyan }
        let sut = VADisplayNode()
        sut.layoutSpecBlock = { _, _ in
            Stack {
                firstRectangleNode
                secondRectangleNode
            }
        }

        assertNodeSnapshot(matching: sut, size: .auto)
    }

    func test_stack_fixed_size() {
        let firstRectangleNode = ASDisplayNode()
            .maxConstrained(width: 36, height: 24)
            .apply { $0.backgroundColor = .orange }
        let secondRectangleNode = ASDisplayNode()
            .maxConstrained(width: 24, height: 36)
            .apply { $0.backgroundColor = .cyan }
        let sut = VADisplayNode()
        sut.layoutSpecBlock = { _, _ in
            Stack {
                firstRectangleNode
                secondRectangleNode
            }
        }

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 48)))
    }
}
