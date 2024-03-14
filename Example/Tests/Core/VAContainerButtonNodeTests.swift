//
//  VAContainerButtonNodeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 23.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class VAContainerButtonNodeTests: XCTestCase {
    var sut: VAContainerButtonNode<VATextNode>!
    let childTextNode = VATextNode(text: "Title")

    override func tearDown() {
        sut = nil
    }

    func test_onTap() {
        let receiver = MockTapReceiver()
        sut = VAContainerButtonNode(child: childTextNode, onTap: { [weak receiver] in
            receiver?.isTapped = true
        })
        sut.loadForPreview()
        sut.sendActions(forControlEvents: .touchUpInside, with: nil)

        XCTAssertTrue(receiver.isTapped)
    }
}
