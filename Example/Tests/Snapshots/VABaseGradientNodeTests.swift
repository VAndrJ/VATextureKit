//
//  VABaseGradientNodeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 05.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
import AsyncDisplayKit
import SnapshotTesting
import VATextureKit

class VABaseGradientNodeTests: XCTestCase {

    func test_node_blend_mode_no_blend() {
        let sut = generateSUT(blendMode: nil)

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 24)))
    }

    func test_node_blend_modes() {
        ASDisplayNode.BlendMode.allCases.forEach {
            let sut = generateSUT(blendMode: $0)

            assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 24)), additions: "\($0)")
        }
    }

    func test_node_compositing_filters() {
        ASDisplayNode.CompositingFilter.allCases.forEach {
            let sut = generateSUT(compositingFilter: $0)

            assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 24)), additions: "\($0)")
        }
    }

    private func generateSUT(compositingFilter: ASDisplayNode.CompositingFilter?) -> ASDisplayNode {
        let sut = ASDisplayNode()
        sut.backgroundColor = .gray
        let gradient = VALinearGradientNode(gradient: .vertical)
        gradient.update(colors: (.white.withAlphaComponent(0.5), 0), (.orange.withAlphaComponent(0.5), 1))
        gradient.compositingFilter = compositingFilter
        sut.addSubnode(gradient)
        sut.layoutSpecBlock = { _, _ in gradient.wrapped() }
        return sut
    }

    private func generateSUT(blendMode: ASDisplayNode.BlendMode?) -> ASDisplayNode {
        let sut = ASDisplayNode()
        sut.backgroundColor = .gray
        let gradient = VALinearGradientNode(gradient: .vertical)
        gradient.update(colors: (.white.withAlphaComponent(0.5), 0), (.orange.withAlphaComponent(0.5), 1))
        gradient.blendMode = blendMode
        sut.addSubnode(gradient)
        sut.layoutSpecBlock = { _, _ in gradient.wrapped() }
        return sut
    }
}
