//
//  ActorCardNodeTests.swift
//  MoviesSnapshotTests
//
//  Created by VAndrJ on 15.04.2023.
//

import XCTest
@testable import MoviesExample

@MainActor
class ActorCardNodeTests: XCTestCase {

    func test_node_short() {
        let sut = ActorCardNode(context: .init(listActor: .dummy()))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(75))
    }

    func test_node_long() {
        let sut = ActorCardNode(context: .init(listActor: .dummy(repeatingString: 3)))

        assertNodeSnapshot(matching: sut, size: .freeHeightFixedWidth(75))
    }
}
