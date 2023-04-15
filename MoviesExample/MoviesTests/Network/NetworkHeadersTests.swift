//
//  NetworkHeadersTests.swift
//  MoviesTests
//
//  Created by VAndrJ on 15.04.2023.
//

import XCTest
@testable import MoviesExample

final class NetworkHeadersTests: XCTestCase {
    private var standardMappedHeaders: [String: String] {
        Dictionary(
            NetworkHeaders.standard.map { ($0.key.rawValue, $0.value.rawValue) },
            uniquingKeysWith: { $1 }
        )
    }

    func test_headers_default() {
        let sut = NetworkHeaders(additionalRawHeaders: [:])

        XCTAssertEqual(
            standardMappedHeaders,
            sut.values
        )
    }

    func test_headers_merging() {
        let sut = NetworkHeaders(additionalHeaders: [.authorization: .bearer(token: "token")])

        XCTAssertEqual(
            standardMappedHeaders.merging(["Authorization": "Bearer token"], uniquingKeysWith: { $1 }),
            sut.values
        )
    }

    func test_headers_tokenRawMerging() {
        let sut = NetworkHeaders(token: "token", headers: ["test": "test"])

        XCTAssertEqual(
            standardMappedHeaders.merging(["Authorization": "Bearer token", "test": "test"], uniquingKeysWith: { $1 }),
            sut.values
        )
    }

    func test_headers_tokenRawMergingOverwrite() {
        let sut = NetworkHeaders(token: "token", headers: ["platform": "test"])

        XCTAssertEqual(
            standardMappedHeaders.merging(["platform": "test", "Authorization": "Bearer token"], uniquingKeysWith: { $1 }),
            sut.values
        )
    }

    func test_headers_mergingOverwrite() {
        let sut = NetworkHeaders(additionalHeaders: [.platform: .bearer(token: "token")])

        XCTAssertEqual(
            standardMappedHeaders.merging(["platform": "Bearer token"], uniquingKeysWith: { $1 }),
            sut.values
        )
    }

    func test_headers_tokenMerging() {
        let sut = NetworkHeaders(token: "token")

        XCTAssertEqual(
            standardMappedHeaders.merging(["Authorization": "Bearer token"], uniquingKeysWith: { $1 }),
            sut.values
        )
    }

    func test_headers_rawMerging() {
        let sut = NetworkHeaders(additionalRawHeaders: ["test": "test"])

        XCTAssertEqual(
            standardMappedHeaders.merging(["test": "test"], uniquingKeysWith: { $1 }),
            sut.values
        )
    }

    func test_headers_rawMergingOverwrite() {
        let sut = NetworkHeaders(additionalRawHeaders: ["platform": "test"])

        XCTAssertEqual(
            standardMappedHeaders.merging(["platform": "test"], uniquingKeysWith: { $1 }),
            sut.values
        )
    }
}
