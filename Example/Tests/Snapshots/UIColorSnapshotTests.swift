//
//  UIColorSnapshotTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 14.03.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import XCTest
import SnapshotTesting
import VATextureKit

class UIColorSnapshotTests: XCTestCase {

    func test_average() {
        let color = [UIColor.red, .blue].average
        let sut = generateSUT(color: color)

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 24)))
    }

    func test_opaque() {
        let color = UIColor.green.withAlphaComponent(0.1).opaque(on: .white)
        let sut = generateSUT(color: color)

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 24)))
    }

    func test_opaque_lightTrait() {
        let color = UIColor.systemPurple.withAlphaComponent(0.5).opaque(on: .white, traitCollection: UITraitCollection(userInterfaceStyle: .light))
        let sut = generateSUT(color: color)

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 24)))
    }

    func test_opaque_darkTrait() {
        let color = UIColor.systemPurple.withAlphaComponent(0.5).opaque(on: .white, traitCollection: UITraitCollection(userInterfaceStyle: .dark))
        let sut = generateSUT(color: color)

        assertNodeSnapshot(matching: sut, size: .fixed(CGSize(same: 24)))
    }

    private func generateSUT(color: UIColor) -> ASDisplayNode {
        let sut = ASDisplayNode()
        sut.backgroundColor = color

        return sut
    }
}
