//
//  LayoutSpecBuilderTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 18.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class LayoutSpecBuilderTests: XCTestCase {
    let node1 = ASDisplayNode()
    let node2 = ASDisplayNode()
    let node3 = ASDisplayNode()
    let node4 = ASDisplayNode()

    func test_build() {
        let spec = Row {
            node1
        }
        XCTAssertTrue(spec.children?.first === node1)
    }

    func test_build_multiple() {
        let spec = Row {
            node1
            node2
        }
        XCTAssertTrue(spec.children?.first === node1)
    }

    func test_build_array() {
        let spec = Row {
            [
                node1,
                node2,
            ]
        }
        XCTAssertTrue(spec.children?.first === node1)
    }

    func test_build_if_true() {
        let flag = true
        let spec = Row {
            if flag {
                node1
            } else {
                node2
            }
        }
        XCTAssertTrue(spec.children?.first === node1)
    }

    func test_build_if_true_multiple() {
        let flag = true
        let spec = Row {
            if flag {
                node1
                node3
            } else {
                node2
                node4
            }
        }
        XCTAssertTrue(spec.children?.first === node1)
    }

    func test_build_if_true_array() {
        let flag = true
        let spec = Row {
            if flag {
                [
                    node1,
                    node3,
                ]
            } else {
                [
                    node2,
                    node4,
                ]
            }
        }
        XCTAssertTrue(spec.children?.first === node1)
    }

    func test_build_if_false() {
        let flag = false
        let spec = Row {
            if flag {
                node1
            } else {
                node2
            }
        }
        XCTAssertTrue(spec.children?.first === node2)
    }

    func test_build_if_false_multiple() {
        let flag = false
        let spec = Row {
            if flag {
                node1
                node3
            } else {
                node2
                node4
            }
        }
        XCTAssertTrue(spec.children?.first === node2)
    }

    func test_build_if_false_array() {
        let flag = false
        let spec = Row {
            if flag {
                [
                    node1,
                    node3,
                ]
            } else {
                [
                    node2,
                    node4,
                ]
            }
        }
        XCTAssertTrue(spec.children?.first === node2)
    }

    func test_build_optional() {
        let optionalNode: ASDisplayNode? = node1
        let spec = Row {
            if let optionalNode {
                optionalNode
            }
            node2
        }
        XCTAssertTrue(spec.children?.first === node1)
    }
}
