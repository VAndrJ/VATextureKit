//
//  VAContainerButtonNodeSnapshotTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 23.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
import SnapshotTesting
import VATextureKit

class VAContainerButtonNodeSnapshotTests: XCTestCase {
    private let childNode = ASDisplayNode().sized(CGSize(same: 24)).apply {
        $0.backgroundColor = .blue
    }

    func test_node() {
        let sut = VAContainerButtonNode(child: childNode)
        sut.backgroundColor = .orange

        assertNodeSnapshot(matching: sut, size: .auto)
    }

    func test_node_insets() {
        let sut = VAContainerButtonNode(child: childNode, insets: UIEdgeInsets(all: 16))
        sut.backgroundColor = .orange

        assertNodeSnapshot(matching: sut, size: .auto)
    }

    func test_node_childCentering() {
        let sut = VAContainerButtonNode(child: childNode)
        sut.backgroundColor = .orange

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 48)))
    }

    func test_node_highlighting() {
        let sut = VAContainerButtonNode(child: childNode, onStateChange: {
            $0.child.alpha = $1 == .highlighted ? 0.4 : 1
        })
        sut.backgroundColor = .orange
        sut.isHighlighted = true

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 48)))
    }

    func test_node_disabled() {
        let sut = VAContainerButtonNode(child: childNode, onStateChange: {
            $0.alpha = $1 == .disabled ? 0.1 : 1
        })
        sut.backgroundColor = .orange
        sut.isEnabled = false

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 48)))
    }

    func test_node_selected() {
        let sut = VAContainerButtonNode(child: childNode, onStateChange: {
            $0.alpha = $1 == .selected ? 0.6 : 1
        })
        sut.backgroundColor = .orange
        sut.isSelected = true

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 48)))
    }

    func test_node_selectedHighlighted() {
        let sut = VAContainerButtonNode(child: childNode, onStateChange: {
            $0.alpha = $1 == [.selected, .highlighted] ? 0.6 : 1
            $0.child.alpha = $1 == [.selected, .highlighted] ? 0.4 : 1
        })
        sut.backgroundColor = .orange
        sut.isSelected = true
        sut.isHighlighted = true

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 48)))
    }

    func test_node_insetsChange() {
        let sut = VAContainerButtonNode(child: childNode)
        sut.backgroundColor = .orange
        sut.insets = UIEdgeInsets(all: 8)

        assertNodeSnapshot(matching: sut, size: .auto)
    }
}
