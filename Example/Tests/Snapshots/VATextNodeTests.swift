//
//  VATextNodeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 25.05.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
import SnapshotTesting
import VATextureKit

class VATextNodeTests: XCTestCase {

    override func setUp() {
        appContext.themeManager.setLightAsCustomTheme()
    }

    func test_node_short() {
        let sut = generateSUT(text: "Text")

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_long() {
        let sut = generateSUT()

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_kern_fixed() {
        let sut = generateSUT(kern: .fixed(-1))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_kern_relative() {
        let sut = generateSUT(kern: .relative(-10))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_kern_custom() {
        let sut = generateSUT(kern: .custom({ $0 * 0.05 }))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_lineHeight_fixed() {
        let sut = generateSUT(lineHeight: .fixed(30))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_lineHeight_proportional() {
        let sut = generateSUT(lineHeight: .proportional(200))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_lineHeight_custom() {
        let sut = generateSUT(lineHeight: .custom({ $0 * 2 }))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    func test_node_secondary() {
        let sut = generateSUT(
            text: "Text test string example".dummyLong(repeating: 21),
            secondary: [
                .init(
                    strings: ["test", "example"],
                    colorGetter: { $0.systemOrange }
                ),
                .init(
                    strings: ["string"],
                    fontGetter: { contentSize, theme in
                        theme.font(.design(
                            .default,
                            size: VAFontStyle.caption2.getFontSize(contentSize: contentSize),
                            weight: VAFontStyle.caption2.weight
                        ))
                    },
                    kern: .relative(10),
                    colorGetter: { $0.systemGreen }
                ),
            ]
        )

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320))
    }

    private func generateSUT(
        text: String = "Text".dummyLong(repeating: 21),
        kern: VAKern? = nil,
        lineHeight: VALineHeight? = nil,
        secondary: [VATextNode.SecondaryAttributes] = []
    ) -> VATextNode {
        VATextNode(
            text: text,
            fontStyle: .headline,
            kern: kern,
            lineHeight: lineHeight,
            alignment: .left,
            truncationMode: .byTruncatingTail,
            maximumNumberOfLines: 2,
            colorGetter: { $0.label },
            secondary: secondary
        )
    }
}
