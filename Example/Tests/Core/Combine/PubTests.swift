//
//  PubTests.swift
//  VATextureKit_Tests
//
//  Created by VAndrJ on 05.06.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKitCombine
import Combine

class PubTests: XCTestCase {

    func test_PassthroughSubject() {
        @Pub.Subject()
        var sut: AnyPublisher<String, Never>

        let spy = spy(sut)
        let expected = ["", "1", "2"]
        expected.forEach {
            _sut.send($0)
        }

        XCTAssertEqual(expected, spy.result)
    }

    func test_PassthroughSubject_Void() {
        @Pub.Subject()
        var sut: AnyPublisher<Void, Never>

        let spy = spy(sut)
        let expected = 2
        (0..<expected).forEach { _ in
            _sut.send()
        }

        XCTAssertEqual(expected, spy.result.count)
    }

    func test_PassthroughSubject_Mapped() {
        @Pub.Subject(map: { $0 + $0 })
        var sut: AnyPublisher<String, Never>

        let spy = spy(sut)
        let values = ["", "1", "2"]
        values.forEach {
            _sut.send($0)
        }
        let expected = values.map { $0 + $0 }

        XCTAssertEqual(expected, spy.result)
    }

    func test_PassthroughSubject_MappedError() {
        @Pub.Subject(mapError: { (error: MockError1) in error.mapped })
        var sut: AnyPublisher<String, MockError2>

        let spy = spy(sut)
        let expected = ["", "1", "2"]
        expected.forEach {
            _sut.send($0)
        }
        _sut.send(completion: .failure(.mock1Error))

        XCTAssertEqual(expected, spy.result)
        XCTAssertEqual(MockError2.mock2Error, spy.failure)
    }

    func test_PassthroughSubject_MappedWithError() {
        @Pub.Subject(map: { $0 + $0 }, mapError: { (error: MockError1) in error.mapped })
        var sut: AnyPublisher<String, MockError2>

        let spy = spy(sut)
        let values = ["1", "2", "3"]
        values.forEach {
            _sut.send($0)
        }
        _sut.send(completion: .failure(.mock1Error))
        let expected = values.map { $0 + $0 }

        XCTAssertEqual(expected, spy.result)
        XCTAssertEqual(MockError2.mock2Error, spy.failure)
    }

    func test_PassthroughSubject_MappedInputOutput() {
        @Pub.Subject(map: { (value: Int) in String(value) })
        var sut: AnyPublisher<String, Never>

        let spy = spy(sut)
        let values = [0, 1, 2]
        values.forEach {
            _sut.send($0)
        }
        let expected = values.map { String($0) }

        XCTAssertEqual(expected, spy.result)
    }

    func test_CurrentValueSubject() {
        let initial = ""
        @Pub.Subject(initial)
        var sut: AnyPublisher<String, Never>

        let spy = spy(sut)
        let expected = CollectionOfOne(initial) + ["", "1", "2"]
        expected.dropFirst().forEach {
            _sut.send($0)
        }

        XCTAssertEqual(expected, spy.result)
    }

    func test_CurrentValueSubject_Value() {
        let initial = ""
        @Pub.Subject(initial)
        var sut: AnyPublisher<String, Never>

        let expected1 = "1"
        _sut.send(expected1)

        XCTAssertEqual(expected1, _sut.value)

        let expected2 = "1111"
        _sut.send(expected2)

        XCTAssertEqual(expected2, _sut.value)
    }

    func test_CurrentValueSubject_Mapped() {
        let initial = ""
        @Pub.Subject(initial, map: { $0 + $0 })
        var sut: AnyPublisher<String, Never>

        let spy = spy(sut)
        let values = ["", "1", "2"]
        values.forEach {
            _sut.send($0)
        }
        let expected = CollectionOfOne(initial) + values.map { $0 + $0 }

        XCTAssertEqual(expected, spy.result)
    }

    func test_CurrentValueSubject_MappedInputOutput() {
        let initial = 0
        @Pub.Subject(initial, map: { String($0) })
        var sut: AnyPublisher<String, Never>

        let spy = spy(sut)
        let values = [0, 1, 2]
        values.forEach {
            _sut.send($0)
        }
        let expected = CollectionOfOne("\(initial)") + values.map { String($0) }

        XCTAssertEqual(expected, spy.result)
    }

    func test_CurrentValueSubject_MappedError() {
        let inital = ""
        @Pub.Subject(inital, mapError: { (error: MockError1) in error.mapped })
        var sut: AnyPublisher<String, MockError2>

        let spy = spy(sut)
        let expected = CollectionOfOne(inital) + ["", "1", "2"]
        expected.dropFirst().forEach {
            _sut.send($0)
        }
        _sut.send(completion: .failure(.mock1Error))

        XCTAssertEqual(expected, spy.result)
        XCTAssertEqual(MockError2.mock2Error, spy.failure)
    }

    func test_CurrentValueSubject_MappedWithError() {
        let inital = ""
        @Pub.Subject(inital, map: { $0 + $0 }, mapError: { (error: MockError1) in error.mapped })
        var sut: AnyPublisher<String, MockError2>

        let spy = spy(sut)
        let values = ["1", "2", "3"]
        values.forEach {
            _sut.send($0)
        }
        _sut.send(completion: .failure(.mock1Error))
        let expected = CollectionOfOne(inital) + values.map { $0 + $0 }

        XCTAssertEqual(expected, spy.result)
        XCTAssertEqual(MockError2.mock2Error, spy.failure)
    }
}
