//
//  NetworkErrorTests.swift
//  MoviesTests
//
//  Created by VAndrJ on 15.04.2023.
//

import XCTest
@testable import MoviesExample

final class NetworkErrorTests: XCTestCase {

    func test_description() {
        let string = "string"
        let error = ErrorFromServerResponseDTO(statusMessage: "String", statusCode: 1)
        XCTAssertEqual(NetworkError.emptyRequestData.errorDescription, R.string.localizable.error_request_empty_data())
        XCTAssertEqual(NetworkError.emptyResponseData.errorDescription, R.string.localizable.error_response_empty_data())
        XCTAssertEqual(NetworkError.serverInternal.errorDescription, R.string.localizable.error_server_internal())
        XCTAssertEqual(NetworkError.incorrectEndpointBaseURL(string: string).errorDescription, R.string.localizable.error_request_incorrect_base(string))
        XCTAssertEqual(NetworkError.server(error).errorDescription, error.description)
        XCTAssertEqual(NetworkError.incorrectEndpointURLComponents(path: string, base: string).errorDescription, R.string.localizable.error_request_incorrect_components(string, string))
    }
}
