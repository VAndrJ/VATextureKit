//
//  NetworkPathTests.swift
//  MoviesTests
//
//  Created by VAndrJ on 15.04.2023.
//

import XCTest
@testable import MoviesExample

final class NetworkPathTests: XCTestCase {

    func test_component_raw_value() {
        let id: Id<Movie> = 1
        XCTAssertEqual(id.description, NetworkPath.Component.convertible(id).rawValue)

        let component = NetworkPath.Component.credits
        XCTAssertEqual("\(component)", component.rawValue)
    }
}
