//
//  ASLayoutElementTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 01.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class ASLayoutElementTests: XCTestCase {

    func test_sized_size() {
        let expected = CGSize(same: 100)
        let element = ASDisplayNode()
            .sized(expected)

        XCTAssertEqual(expected, element.style.preferredSize)
    }

    func test_sized_width() {
        let expected = 100.0
        let element = ASDisplayNode()
            .sized(width: expected)

        XCTAssertEqual(expected, element.style.width.value)
    }

    func test_sized_height() {
        let expected = 100.0
        let element = ASDisplayNode()
            .sized(height: expected)

        XCTAssertEqual(expected, element.style.height.value)
    }

    func test_sized_widthDimension() {
        let expected: ASDimension = .fraction(0.2)
        let element = ASDisplayNode()
            .sized(width: expected)

        XCTAssertEqual(expected, element.style.width)
    }

    func test_sized_heightDimension() {
        let expected: ASDimension = .fraction(0.2)
        let element = ASDisplayNode()
            .sized(height: expected)

        XCTAssertEqual(expected, element.style.height)
    }

    func test_flex_shrink() {
        let expected = 0.1
        let element = ASDisplayNode()
            .flex(shrink: expected)

        XCTAssertEqual(expected, element.style.flexShrink)
    }

    func test_flex_grow() {
        let expected = 0.1
        let element = ASDisplayNode()
            .flex(grow: expected)

        XCTAssertEqual(expected, element.style.flexGrow)
    }

    func test_flex_basis() {
        let expected = 0.1
        let element = ASDisplayNode()
            .flex(basisPercent: expected * 100)

        XCTAssertEqual(expected, element.style.flexBasis.value)
    }

    func test_maxConstrained_size() {
        let expected = CGSize(same: 100)
        let element = ASDisplayNode()
            .maxConstrained(size: expected)

        XCTAssertEqual(expected.width, element.style.maxWidth.value)
        XCTAssertEqual(expected.height, element.style.maxHeight.value)
    }

    func test_maxConstrained_width() {
        let expected = 10.0
        let element = ASDisplayNode()
            .maxConstrained(width: expected)

        XCTAssertEqual(expected, element.style.maxWidth.value)
    }

    func test_maxConstrained_height() {
        let expected = 10.0
        let element = ASDisplayNode()
            .maxConstrained(height: expected)

        XCTAssertEqual(expected, element.style.maxHeight.value)
    }

    func test_maxConstrained_widthDimension() {
        let expected: ASDimension = .points(10)
        let element = ASDisplayNode()
            .maxConstrained(width: expected)

        XCTAssertEqual(expected, element.style.maxWidth)
    }

    func test_maxConstrained_heightDimension() {
        let expected: ASDimension = .points(10)
        let element = ASDisplayNode()
            .maxConstrained(height: expected)

        XCTAssertEqual(expected, element.style.maxHeight)
    }

    func test_minConstrained_size() {
        let expected = CGSize(same: 100)
        let element = ASDisplayNode()
            .minConstrained(size: expected)

        XCTAssertEqual(expected.width, element.style.minWidth.value)
        XCTAssertEqual(expected.height, element.style.minHeight.value)
    }

    func test_minConstrained_width() {
        let expected = 10.0
        let element = ASDisplayNode()
            .minConstrained(width: expected)

        XCTAssertEqual(expected, element.style.minWidth.value)
    }

    func test_minConstrained_height() {
        let expected = 10.0
        let element = ASDisplayNode()
            .minConstrained(height: expected)

        XCTAssertEqual(expected, element.style.minHeight.value)
    }

    func test_minConstrained_widthDimension() {
        let expected: ASDimension = .points(10)
        let element = ASDisplayNode()
            .minConstrained(width: expected)

        XCTAssertEqual(expected, element.style.minWidth)
    }

    func test_minConstrained_heightDimension() {
        let expected: ASDimension = .points(10)
        let element = ASDisplayNode()
            .minConstrained(height: expected)

        XCTAssertEqual(expected, element.style.minHeight)
    }

    func test_spec_absolute() {
        let expected = CGRect(x: 10, y: 10, width: 10, height: 10)
        let expectedSizing: ASAbsoluteLayoutSpecSizing = .sizeToFit
        let node = ASDisplayNode()
        let element = node
            .absolutely(frame: expected, sizing: expectedSizing)

        XCTAssertEqual(expectedSizing, element.sizing)
        XCTAssertEqual(expected.origin, node.style.layoutPosition)
        XCTAssertEqual(expected.size, node.style.preferredSize)
    }

    func test_spec_background() {
        let node = ASDisplayNode()
        let element = ASDisplayNode()
            .background(node)

        XCTAssertEqual(node, element.background as? ASDisplayNode)
    }

    func test_spec_overlay() {
        let node = ASDisplayNode()
        let element = ASDisplayNode()
            .overlay(node)

        XCTAssertEqual(node, element.overlay as? ASDisplayNode)
    }

    func test_spec_ratio() {
        let expected = 1.0 / 3.0
        let element = ASDisplayNode()
            .ratio(expected)

        XCTAssertEqual(expected, element.ratio)
    }

    func test_spec_centered() {
        let expectedCentering: ASCenterLayoutSpecCenteringOptions = .X
        let expectedSizing: ASCenterLayoutSpecSizingOptions = .minimumX
        let element = ASDisplayNode()
            .centered(expectedCentering, sizing: expectedSizing)

        XCTAssertEqual(expectedCentering, element.centeringOptions)
        XCTAssertEqual(expectedSizing, element.sizingOptions)
    }

    func test_spec_padding() {
        let expected = 16.0
        let element = ASDisplayNode()
            .padding(.all(expected))

        XCTAssertEqual(UIEdgeInsets(all: expected), element.insets)
    }

    func test_spec_wrapped() {
        let node = ASDisplayNode()
        let element = node
            .wrapped()

        XCTAssertEqual(node, element.child as? ASDisplayNode)
    }

    func test_spec_corner() {
        let node = ASDisplayNode()
        let location: ASCornerLayoutLocation = .bottomRight
        let offset = CGPoint(x: 10, y: 10)
        let wrapsCorner = false
        let element = ASDisplayNode()
            .corner(node, location: location, offset: offset, wrapsCorner: wrapsCorner)

        XCTAssertEqual(node, element.corner as? ASDisplayNode)
        XCTAssertEqual(location, element.cornerLocation)
        XCTAssertEqual(offset, element.offset)
        XCTAssertEqual(wrapsCorner, element.wrapsCorner)
    }

    func test_spec_safe() {
        let node = ASDisplayNode()
        let element = ASDisplayNode()
            .safe(edges: .all, in: node)

        XCTAssertEqual(node.safeAreaInsets, element.insets)
    }

    func test_sized_sizeArray() {
        let nodes = [ASDisplayNode(), ASDisplayNode()]
        let expected = CGSize(same: 100)
        let elements = nodes.sized(expected)

        elements.forEach {
            XCTAssertEqual(expected, $0.style.preferredSize)
        }
    }

    func test_sized_widthArray() {
        let nodes = [ASDisplayNode(), ASDisplayNode()]
        let expected = 100.0
        let elements = nodes.sized(width: expected)

        elements.forEach {
            XCTAssertEqual(expected, $0.style.width.value)
        }
    }

    func test_sized_heightArray() {
        let nodes = [ASDisplayNode(), ASDisplayNode()]
        let expected = 100.0
        let elements = nodes.sized(height: expected)

        elements.forEach {
            XCTAssertEqual(expected, $0.style.height.value)
        }
    }

    func test_sized_widthDimensionArray() {
        let nodes = [ASDisplayNode(), ASDisplayNode()]
        let expected: ASDimension = .points(10)
        let elements = nodes.sized(width: expected)

        elements.forEach {
            XCTAssertEqual(expected, $0.style.width)
        }
    }

    func test_sized_heightDimensionArray() {
        let nodes = [ASDisplayNode(), ASDisplayNode()]
        let expected: ASDimension = .points(10)
        let elements = nodes.sized(height: expected)

        elements.forEach {
            XCTAssertEqual(expected, $0.style.height)
        }
    }

    func test_flex_shrinkArray() {
        let nodes = [ASDisplayNode(), ASDisplayNode()]
        let expected = 0.1
        let elements = nodes.flex(shrink: expected)

        elements.forEach {
            XCTAssertEqual(expected, $0.style.flexShrink)
        }
    }

    func test_flex_growArray() {
        let nodes = [ASDisplayNode(), ASDisplayNode()]
        let expected = 0.1
        let elements = nodes.flex(grow: expected)

        elements.forEach {
            XCTAssertEqual(expected, $0.style.flexGrow)
        }
    }

    func test_flex_basisArray() {
        let nodes = [ASDisplayNode(), ASDisplayNode()]
        let expected = 0.1
        let elements = nodes.flex(basisPercent: expected * 100)

        elements.forEach {
            XCTAssertEqual(expected, $0.style.flexBasis.value)
        }
    }

    func test_maxConstrained_sizeArray() {
        let nodes = [ASDisplayNode(), ASDisplayNode()]
        let expected = CGSize(same: 100)
        let elements = nodes.maxConstrained(size: expected)

        elements.forEach {
            XCTAssertEqual(expected.width, $0.style.maxWidth.value)
            XCTAssertEqual(expected.height, $0.style.maxHeight.value)
        }
    }

    func test_maxConstrained_widthArray() {
        let nodes = [ASDisplayNode(), ASDisplayNode()]
        let expected = 100.0
        let elements = nodes.maxConstrained(width: expected)

        elements.forEach {
            XCTAssertEqual(expected, $0.style.maxWidth.value)
        }
    }

    func test_maxConstrained_heightArray() {
        let nodes = [ASDisplayNode(), ASDisplayNode()]
        let expected = 100.0
        let elements = nodes.maxConstrained(height: expected)

        elements.forEach {
            XCTAssertEqual(expected, $0.style.maxHeight.value)
        }
    }

    func test_maxConstrained_widthDimensionArray() {
        let nodes = [ASDisplayNode(), ASDisplayNode()]
        let expected: ASDimension = .points(10)
        let elements = nodes.maxConstrained(width: expected)
        
        elements.forEach {
            XCTAssertEqual(expected, $0.style.maxWidth)
        }
    }

    func test_maxConstrained_heightDimensionArray() {
        let nodes = [ASDisplayNode(), ASDisplayNode()]
        let expected: ASDimension = .points(10)
        let elements = nodes.maxConstrained(height: expected)

        elements.forEach {
            XCTAssertEqual(expected, $0.style.maxHeight)
        }
    }

    func test_minConstrained_sizeArray() {
        let nodes = [ASDisplayNode(), ASDisplayNode()]
        let expected = CGSize(same: 100)
        let elements = nodes.minConstrained(size: expected)

        elements.forEach {
            XCTAssertEqual(expected.width, $0.style.minWidth.value)
            XCTAssertEqual(expected.height, $0.style.minHeight.value)
        }
    }

    func test_minConstrained_widthArray() {
        let nodes = [ASDisplayNode(), ASDisplayNode()]
        let expected = 100.0
        let elements = nodes.minConstrained(width: expected)

        elements.forEach {
            XCTAssertEqual(expected, $0.style.minWidth.value)
        }
    }

    func test_minConstrained_heightArray() {
        let nodes = [ASDisplayNode(), ASDisplayNode()]
        let expected = 100.0
        let elements = nodes.minConstrained(height: expected)

        elements.forEach {
            XCTAssertEqual(expected, $0.style.minHeight.value)
        }
    }

    func test_minConstrained_widthDimensionArray() {
        let nodes = [ASDisplayNode(), ASDisplayNode()]
        let expected: ASDimension = .points(10)
        let elements = nodes.minConstrained(width: expected)

        elements.forEach {
            XCTAssertEqual(expected, $0.style.minWidth)
        }
    }

    func test_minConstrained_heightDimensionArray() {
        let nodes = [ASDisplayNode(), ASDisplayNode()]
        let expected: ASDimension = .points(10)
        let elements = nodes.minConstrained(height: expected)

        elements.forEach {
            XCTAssertEqual(expected, $0.style.minHeight)
        }
    }
}
