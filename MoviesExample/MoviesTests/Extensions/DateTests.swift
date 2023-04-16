//
//  DateTests.swift
//  MoviesTests
//
//  Created by VAndrJ on 16.04.2023.
//

import XCTest
@testable import MoviesExample

final class DateTests: XCTestCase {

    func test_readable_string() {
        let expected = "01/01/1970 00:00:00.000"
        DateFormatter.readableDateFormatter.timeZone = TimeZone(identifier: "UTC+0")

        XCTAssertEqual(expected, Date(timeIntervalSince1970: 0).readableString)
    }
}
