//
//  VASpacerNodeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 19.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
import SnapshotTesting
import VATextureKit

class VASpacerNodeTests: XCTestCase {

    func test_node_mid() {
        let sut = VADisplayNode().apply {
            $0.backgroundColor = .green
        }
        let topNode = VADisplayNode()
            .sized(height: 4)
            .apply {
                $0.backgroundColor = .black
            }
        let bottomNode = VADisplayNode()
            .sized(height: 4)
            .apply {
                $0.backgroundColor = .brown
            }
        let spacerNode = VASpacerNode()

        sut.layoutSpecBlock = { _, _ in
            Column {
                topNode
                spacerNode
                bottomNode
            }
        }

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(width: 24, height: 48)))
    }

    func test_node_proportional() {
        let sut = VADisplayNode().apply {
            $0.backgroundColor = .green
        }
        let topNode = VADisplayNode()
            .sized(height: 4)
            .apply {
                $0.backgroundColor = .black
            }
        let bottomNode = VADisplayNode()
            .sized(height: 4)
            .apply {
                $0.backgroundColor = .brown
            }
        let topSpacerNode = VASpacerNode(flexShrink: 0.1, flexGrow: 0.25)
        let midSpacerNode = VASpacerNode(flexShrink: 0.2, flexGrow: 0.5)
        let bottomSpacerNode = VASpacerNode(flexShrink: 0.3, flexGrow: 0.75)

        sut.layoutSpecBlock = { _, _ in
            Column {
                topSpacerNode
                topNode
                midSpacerNode
                bottomNode
                bottomSpacerNode
            }
        }

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(width: 24, height: 48)))
    }
}
