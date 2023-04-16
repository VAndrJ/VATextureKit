//
//  ShimmerCellNodeTests.swift
//  MoviesSnapshotTests
//
//  Created by VAndrJ on 15.04.2023.
//

import XCTest
@testable import MoviesExample

@MainActor
class ShimmerCellNodeTests: XCTestCase {

    func test_node() {
        ShimmerCellNodeViewModel.Kind.allCases.forEach { kind in
            let sut = ShimmerCellNode(viewModel: .init(kind: kind)).contentNode

            assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(320), additions: "\(kind)")
        }
    }
}
