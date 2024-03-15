//
//  NetworkResponseParserTests.swift
//  MoviesTests
//
//  Created by VAndrJ on 15.04.2023.
//

import XCTest
@testable import MoviesExample

final class NetworkResponseParserTests: XCTestCase {
    let sut = NetworkResponseParser(
        dateDecodingStrategy: .millisecondsSince1970,
        keyDecodingStrategy: .convertFromSnakeCase
    )

    func test_decoding_emptyDataError() {
        do {
            let _ = try sut.parse(data: nil, type: TestResponseDTO.self)
            
            XCTFail()
        } catch {
            XCTAssertEqual(NetworkError.emptyResponseData, error as! NetworkError)
        }
    }

    func test_decoding_snakeCaseKeys() throws {
        let expected = TestResponseDTO(camelCase: "value", date: Date(timeIntervalSince1970: 0))

        let data = getStringData(from: expected)

        XCTAssertEqual(
            TestResponseDTO(camelCase: "value", date: Date(timeIntervalSince1970: 0)),
            try sut.parse(data: data)
        )
    }

    func test_decoding_camelCaseKeys() throws {
        let expected = TestResponseDTO(camelCase: "value", date: Date(timeIntervalSince1970: 0))

        let data = getStringData(from: expected)

        XCTAssertEqual(expected, try sut.parse(data: data))
    }

    private func getStringData(from expectedStruct: TestResponseDTO) -> Data {
        """
        {
          "camelCase": "\(expectedStruct.camelCase)",
          "date": \(expectedStruct.date.timeIntervalSince1970)
        }
        """.data(using: .utf8)!
    }
}

struct TestResponseDTO: Codable, Equatable {
    let camelCase: String
    let date: Date
}
