//
//  VAViewWrapperNodeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 24.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

@MainActor
class VAViewWrapperNodeTests: XCTestCase {

    func test_node() {
        let frame = CGRect(origin: .zero, size: CGSize(same: 100))
        let expectedSize = CGSize.zero
        let childView = UIView()
        childView.frame = frame
        let sut = VAViewWrapperNode(childGetter: { childView })
        sut.loadForPreview()

        XCTAssertEqual(expectedSize, sut.style.preferredSize)
    }

    func test_node_inheritedWidth() {
        let frame = CGRect(origin: .zero, size: CGSize(same: 100))
        let expectedSize = CGSize(width: frame.size.width, height: 0)
        let childView = UIView()
        childView.frame = frame
        let sut = VAViewWrapperNode(childGetter: { childView }, sizing: .inheritedWidth)
        sut.loadForPreview()

        XCTAssertEqual(expectedSize, sut.style.preferredSize)
    }

    func test_node_inheritedHeight() {
        let frame = CGRect(origin: .zero, size: CGSize(same: 100))
        let expectedSize = CGSize(width: 0, height: frame.size.height)
        let childView = UIView()
        childView.frame = frame
        let sut = VAViewWrapperNode(childGetter: { childView }, sizing: .inheritedHeight)
        sut.loadForPreview()

        XCTAssertEqual(expectedSize, sut.style.preferredSize)
    }

    func test_node_inheritedSize() {
        let frame = CGRect(origin: .zero, size: CGSize(same: 100))
        let expectedSize = frame.size
        let childView = UIView()
        childView.frame = frame
        let sut = VAViewWrapperNode(childGetter: { childView }, sizing: .inheritedSize)
        sut.loadForPreview()

        XCTAssertEqual(expectedSize, sut.style.preferredSize)
    }

    func test_node_fixedSize() {
        let frame = CGRect(origin: .zero, size: CGSize(same: 100))
        let expectedSize = frame.size
        let childView = UIView()
        childView.frame = frame
        let sut = VAViewWrapperNode(childGetter: { childView }, sizing: .fixedSize(expectedSize))
        sut.loadForPreview()

        XCTAssertEqual(expectedSize, sut.style.preferredSize)
    }

    func test_node_fixedHeight() {
        let frame = CGRect(origin: .zero, size: CGSize(same: 100))
        let expectedSize = CGSize(width: 0, height: frame.size.height)
        let childView = UIView()
        childView.frame = frame
        let sut = VAViewWrapperNode(childGetter: { childView }, sizing: .fixedHeight(expectedSize.height))
        sut.loadForPreview()

        XCTAssertEqual(expectedSize, sut.style.preferredSize)
    }

    func test_node_fixedWidth() {
        let frame = CGRect(origin: .zero, size: CGSize(same: 100))
        let expectedSize = CGSize(width: frame.size.width, height: 0)
        let childView = UIView()
        childView.frame = frame
        let sut = VAViewWrapperNode(childGetter: { childView }, sizing: .fixedWidth(expectedSize.width))
        sut.loadForPreview()

        XCTAssertEqual(expectedSize, sut.style.preferredSize)
    }
}
