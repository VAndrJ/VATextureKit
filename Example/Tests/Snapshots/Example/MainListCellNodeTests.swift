//
//  MainListCellNodeTests.swift
//  VATextureKit_Example
//
//  Created by VAndrJ on 01.04.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import SnapshotTesting
import VATextureKit

class MainListCellNodeTests: XCTestCase {

    func test_node_short_strings() {
        let sut = MainListCellNode(viewModel: MainListCellNodeViewModel(title: "Title", description: "Description"))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(375))
    }

    func test_node_long_strings() {
        let sut = MainListCellNode(viewModel: MainListCellNodeViewModel(title: "Title".dummyLong(), description: "Description".dummyLong()))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(375))
    }
}
