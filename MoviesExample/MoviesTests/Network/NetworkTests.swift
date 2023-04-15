//
//  NetworkTests.swift
//  MoviesTests
//
//  Created by VAndrJ on 15.04.2023.
//

import XCTest
@testable import MoviesExample

@MainActor
final class NetworkTests: XCTestCase {
    var sut: Network!
    let response = TestResponseDTO(camelCase: "string", date: Date(timeIntervalSince1970: 0))
    let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        return encoder
    }()
    let urlString = "https://google.com"
    let parser = NetworkResponseParser(dateDecodingStrategy: .secondsSince1970, keyDecodingStrategy: .convertFromSnakeCase)

    override func tearDown() {
        sut = nil
    }

    func test_request() {
        sut = Network(networkLogger: DebugNetworkLogger(), coreRequest: { [self] request in
            .just((response: HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, data: try! encoder.encode(response)))
        })
        let spy = spy(sut.request(data: try! NetworkEndpointData<TestResponseDTO>(
            urlString: urlString,
            method: .GET,
            parser: parser
        )))

        XCTAssertEqual([response], spy.result)
    }

    func test_request_errors() {
        sut = Network(networkLogger: DebugNetworkLogger(), coreRequest: { _ in .empty() })

        XCTAssertThrowsError(sut.request(data: try NetworkEndpointData<TestResponseDTO>(
            urlString: "",
            method: .GET,
            parser: parser
        ))) { error in
            XCTAssertEqual(NetworkError.incorrectEndpointBaseURL(string: ""), error as! NetworkError)
        }

        let emptyRequestDataSpy = spy(sut.request(data: NetworkEndpointData<TestResponseDTO>?.none))
        XCTAssertEqual([NetworkError.emptyRequestData], emptyRequestDataSpy.errors.compactMap { $0 as? NetworkError })

        let emptyRawRequestDataSpy = spy(sut.requestRaw(data: NetworkEndpointData<TestResponseDTO>?.none))
        XCTAssertEqual([NetworkError.emptyRequestData], emptyRawRequestDataSpy.errors.compactMap { $0 as? NetworkError })
    }

    func test_request_server_error() {
        let error = ErrorFromServerResponseDTO(statusMessage: "message", statusCode: 400)
        sut = Network(networkLogger: DebugNetworkLogger(), coreRequest: { [self] request in
            .just((response: HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!, data: try! encoder.encode(error)))
        })
        let serverErrorSpy = spy(sut.request(data: try! NetworkEndpointData<TestResponseDTO>(
            urlString: urlString,
            method: .GET,
            parser: parser
        )))
        XCTAssertEqual([NetworkError.server(error)], serverErrorSpy.errors.compactMap { $0 as? NetworkError })
    }

    func test_request_internal_server_error() {
        let error = ErrorFromServerResponseDTO(statusMessage: "message", statusCode: 400)
        sut = Network(networkLogger: DebugNetworkLogger(), coreRequest: { [self] request in
            .just((response: HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!, data: try! encoder.encode(error)))
        })
        let expect = expectation(description: "")
        let internalServerErrorSpy = spy(
            sut.request(data: try! NetworkEndpointData<TestResponseDTO>(
                urlString: urlString,
                method: .GET,
                parser: parser
            )),
            initialExpectation: expect
        )
        wait(for: [expect], timeout: 20)
        XCTAssertEqual([NetworkError.serverInternal], internalServerErrorSpy.errors.compactMap { $0 as? NetworkError })
    }
}
