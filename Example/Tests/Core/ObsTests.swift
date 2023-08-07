//
//  ObsTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 01.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKitRx

class ObsTests: XCTestCase {
    @Obs.Relay()
    var publishObs: Observable<String>
    @Obs.Relay(value: "")
    var relayObs: Observable<String>
    @Obs.Relay(map: { $0 + $0 })
    var publishMappedObs: Observable<String>
    @Obs.Relay(value: "", map: { $0 + $0 })
    var relayMappedObs: Observable<String>
    @Obs.Relay(map: { (value: Int) in String(value) })
    var publishMappedInputOutputObs: Observable<String>
    @Obs.Relay(value: 0, map: { String($0) })
    var relayMappedInputOutputObs: Observable<String>

    func test_PublishRelay() {
        let spy = spy(publishObs)
        let expected = ["", "1", "2"]
        expected.forEach {
            _publishObs.rx.accept($0)
        }

        XCTAssertEqual(expected, spy.result)
    }

    func test_PublishRelay_mapped() {
        let spy = spy(publishMappedObs)
        let values = ["", "1", "2"]
        values.forEach {
            _publishMappedObs.rx.accept($0)
        }
        let expected = values.map { $0 + $0 }

        XCTAssertEqual(expected, spy.result)
    }

    func test_PublishRelay_mappedInputOutput() {
        let spy = spy(publishMappedInputOutputObs)
        let values = [0, 1, 2]
        values.forEach {
            _publishMappedInputOutputObs.rx.accept($0)
        }
        let expected = values.map { String($0) }

        XCTAssertEqual(expected, spy.result)
    }

    func test_BehaviorRelay() {
        let spy = spy(relayObs)
        let expected = ["", "1", "2"]
        expected.forEach {
            _relayObs.rx.accept($0)
        }

        XCTAssertEqual(CollectionOfOne("") + expected, spy.result)
    }

    func test_BehaviorRelay_value() {
        let expected1 = "1"
        _relayObs.rx.accept(expected1)

        XCTAssertEqual(expected1, _relayObs.value)

        let expected2 = "1111"
        _relayObs.rx.accept(expected2)

        XCTAssertEqual(expected2, _relayObs.value)
    }

    func test_BehaviorRelay_mapped() {
        let spy = spy(relayMappedObs)
        let values = ["", "1", "2"]
        values.forEach {
            _relayMappedObs.rx.accept($0)
        }
        let expected = values.map { $0 + $0 }

        XCTAssertEqual(CollectionOfOne("") + expected, spy.result)
    }

    func test_BehaviorRelay_mappedInputOutput() {
        let spy = spy(relayMappedInputOutputObs)
        let values = [0, 1, 2]
        values.forEach {
            _relayMappedInputOutputObs.rx.accept($0)
        }
        let expected = values.map { String($0) }

        XCTAssertEqual(CollectionOfOne("0") + expected, spy.result)
    }
}
