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
import RxSwift
import RxCocoa

class ObsTests: XCTestCase {

    func test_PublishRelay() {
        @Obs.Relay()
        var publishObs: Observable<String>

        let spy = spy(publishObs)
        let expected = ["", "1", "2"]
        expected.forEach {
            _publishObs.rx.accept($0)
        }

        XCTAssertEqual(expected, spy.result)
    }

    func test_PublishRelay_mapped() {
        @Obs.Relay(map: { $0 + $0 })
        var publishMappedObs: Observable<String>

        let spy = spy(publishMappedObs)
        let values = ["", "1", "2"]
        values.forEach {
            _publishMappedObs.rx.accept($0)
        }
        let expected = values.map { $0 + $0 }

        XCTAssertEqual(expected, spy.result)
    }

    func test_PublishRelay_mappedInputOutput() {
        @Obs.Relay(map: { (value: Int) in String(value) })
        var publishMappedInputOutputObs: Observable<String>

        let spy = spy(publishMappedInputOutputObs)
        let values = [0, 1, 2]
        values.forEach {
            _publishMappedInputOutputObs.rx.accept($0)
        }
        let expected = values.map { String($0) }

        XCTAssertEqual(expected, spy.result)
    }

    func test_BehaviorRelay() {
        @Obs.Relay(value: "")
        var relayObs: Observable<String>

        let spy = spy(relayObs)
        let expected = ["", "1", "2"]
        expected.forEach {
            _relayObs.rx.accept($0)
        }

        XCTAssertEqual(CollectionOfOne("") + expected, spy.result)
    }

    func test_BehaviorRelay_value() {
        @Obs.Relay(value: "")
        var relayObs: Observable<String>
        
        let expected1 = "1"
        _relayObs.rx.accept(expected1)

        XCTAssertEqual(expected1, _relayObs.value)

        let expected2 = "1111"
        _relayObs.rx.accept(expected2)

        XCTAssertEqual(expected2, _relayObs.value)
    }

    func test_BehaviorRelay_mapped() {
        @Obs.Relay(value: "", map: { $0 + $0 })
        var relayMappedObs: Observable<String>

        let spy = spy(relayMappedObs)
        let values = ["", "1", "2"]
        values.forEach {
            _relayMappedObs.rx.accept($0)
        }
        let expected = values.map { $0 + $0 }

        XCTAssertEqual(CollectionOfOne("") + expected, spy.result)
    }

    func test_BehaviorRelay_transformed() {
        @Obs.Relay(value: "", map: { $0.flatMap { Observable.just($0 + $0) } })
        var relayMappedObs: Observable<String>

        let spy = spy(relayMappedObs)
        let values = ["", "1", "2"]
        values.forEach {
            _relayMappedObs.rx.accept($0)
        }
        let expected = values.map { $0 + $0 }

        XCTAssertEqual(CollectionOfOne("") + expected, spy.result)
    }

    func test_BehaviorRelay_mappedInputOutput() {
        @Obs.Relay(value: 0, map: { String($0) })
        var relayMappedInputOutputObs: Observable<String>

        let spy = spy(relayMappedInputOutputObs)
        let values = [0, 1, 2]
        values.forEach {
            _relayMappedInputOutputObs.rx.accept($0)
        }
        let expected = values.map { String($0) }

        XCTAssertEqual(CollectionOfOne("0") + expected, spy.result)
    }

    func test_State() {
        @Obs.State var stateVariable = ""

        let spy = spy($stateVariable)
        let values = ["", "1", "2"]
        values.forEach {
            stateVariable = $0
        }

        XCTAssertEqual(CollectionOfOne("") + values, spy.result)
        XCTAssertEqual(values.last, stateVariable)
    }

    func test_PublishSubject() {
        @Obs.Subject()
        var subjectObs: Observable<String>

        let spy = spy(subjectObs)
        let values = ["", "1", "2"]
        values.forEach {
            _subjectObs.rx.onNext($0)
        }

        XCTAssertEqual(values, spy.result)
    }

    func test_PublishSubject_mappedInputOutput() {
        @Obs.Subject(map: { Int($0) })
        var subjectObs: Observable<Int?>

        let spy = spy(subjectObs)
        let values = ["", "1", "2"]
        values.forEach {
            _subjectObs.rx.onNext($0)
        }
        let expected = values.map { Int($0) }

        XCTAssertEqual(expected, spy.result)
    }

    func test_BehaviorSubject() {
        @Obs.Subject(value: "")
        var subjectObs: Observable<String>

        let spy = spy(subjectObs)
        let values = ["", "1", "2"]
        values.forEach {
            _subjectObs.rx.onNext($0)
        }

        XCTAssertEqual(CollectionOfOne("") + values, spy.result)
    }

    func test_BehaviorSubject_mappedInputOutput() {
        @Obs.Subject(value: "0", map: { Int($0) })
        var subjectObs: Observable<Int?>

        let spy = spy(subjectObs)
        let values = ["1", "", "2"]
        values.forEach {
            _subjectObs.rx.onNext($0)
        }
        let expected = (CollectionOfOne("0") + values).map { Int($0) }

        XCTAssertEqual(expected, spy.result)
    }

    func test_BehaviorSubject_transformed() {
        @Obs.Subject(value: "0", map: { $0.flatMap { Observable.just(Int($0)) } })
        var subjectObs: Observable<Int?>

        let spy = spy(subjectObs)
        let values = ["1", "", "2"]
        values.forEach {
            _subjectObs.rx.onNext($0)
        }
        let expected = (CollectionOfOne("0") + values).map { Int($0) }

        XCTAssertEqual(expected, spy.result)
    }

    func test_ReplaySubject() {
        @Obs.Subject(replay: .once)
        var subjectObs: Observable<String>

        let spy = spy(subjectObs)
        let values = ["1", "", "2"]
        values.forEach {
            _subjectObs.rx.onNext($0)
        }

        XCTAssertEqual(values, spy.result)
    }

    func test_ReplaySubject_mappedInputOutput() {
        @Obs.Subject(replay: .once, map: { Int($0) })
        var subjectObs: Observable<Int?>

        let spy = spy(subjectObs)
        let values = ["1", "", "2"]
        values.forEach {
            _subjectObs.rx.onNext($0)
        }
        let expected = values.map { Int($0) }

        XCTAssertEqual(expected, spy.result)
    }

    func test_ReplaySubject_one() {
        @Obs.Subject(replay: .once)
        var subjectObs: Observable<String>

        let values = ["1", "", "2"]
        values.forEach {
            _subjectObs.rx.onNext($0)
        }
        let spy = spy(subjectObs)
        let expected = [values.last]

        XCTAssertEqual(expected, spy.result)
    }

    func test_ReplaySubject_few() {
        @Obs.Subject(replay: .custom(3))
        var subjectObs: Observable<String>

        let values = ["1", "", "2", "3"]
        values.forEach {
            _subjectObs.rx.onNext($0)
        }
        let spy = spy(subjectObs)
        let expected = ["", "2", "3"]

        XCTAssertEqual(expected, spy.result)
    }

    func test_ReplaySubject_none() {
        @Obs.Subject(replay: .none)
        var subjectObs: Observable<String>

        let values = ["1", "", "2", "3"]
        values.forEach {
            _subjectObs.rx.onNext($0)
        }
        let spy = spy(subjectObs)
        let expected: [String] = []

        XCTAssertEqual(expected, spy.result)
    }

    func test_ReplaySubject_all() {
        @Obs.Subject(replay: .all)
        var subjectObs: Observable<String>

        let values = ["1", "", "2", "3", "1", "", "2", "3"]
        values.forEach {
            _subjectObs.rx.onNext($0)
        }
        let spy = spy(subjectObs)

        XCTAssertEqual(values, spy.result)
    }

    func test_ReplaySubject_one_mappedInputOutput() {
        @Obs.Subject(replay: .once, map: { Int($0) })
        var subjectObs: Observable<Int?>

        let values = ["1", "", "2"]
        values.forEach {
            _subjectObs.rx.onNext($0)
        }
        let spy = spy(subjectObs)
        let expected = [values.last.map { Int($0) }]

        XCTAssertEqual(expected, spy.result)
    }

    func test_ReplaySubject_few_mappedInputOutput() {
        @Obs.Subject(replay: .custom(3), map: { Int($0) })
        var subjectObs: Observable<Int?>

        let values = ["1", "", "2", "3"]
        values.forEach {
            _subjectObs.rx.onNext($0)
        }
        let spy = spy(subjectObs)
        let expected = ["", "2", "3"].map { Int($0) }

        XCTAssertEqual(expected, spy.result)
    }

    func test_ReplaySubject_none_mappedInputOutput() {
        @Obs.Subject(replay: .none, map: { Int($0) })
        var subjectObs: Observable<Int?>

        let values = ["1", "", "2", "3"]
        values.forEach {
            _subjectObs.rx.onNext($0)
        }
        let spy = spy(subjectObs)
        let expected: [Int?] = []

        XCTAssertEqual(expected, spy.result)
    }

    func test_ReplaySubject_all_mappedInputOutput() {
        @Obs.Subject(replay: .all, map: { Int($0) })
        var subjectObs: Observable<Int?>

        let values = ["1", "", "2", "3", "1", "", "2", "3"]
        values.forEach {
            _subjectObs.rx.onNext($0)
        }
        let spy = spy(subjectObs)
        let expected = values.map { Int($0) }

        XCTAssertEqual(expected, spy.result)
    }
}
