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
        XCTAssertEqual(NetworkError.emptyRequestData.errorDescription, L.error_request_empty_data())
        XCTAssertEqual(NetworkError.emptyResponseData.errorDescription, L.error_response_empty_data())
        XCTAssertEqual(NetworkError.serverInternal.errorDescription, L.error_server_internal())
        XCTAssertEqual(NetworkError.incorrectEndpointBaseURL(string: string).errorDescription, L.error_request_incorrect_base(string))
        XCTAssertEqual(NetworkError.server(error).errorDescription, error.description)
        XCTAssertEqual(NetworkError.incorrectEndpointURLComponents(path: string, base: string).errorDescription, L.error_request_incorrect_components(string, string))
    }
}
