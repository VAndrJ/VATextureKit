//
//  PublisherToObservableTests.swift
//  VATextureKit_Example
//
//  Created by VAndrJ on 05.06.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKitRx
import RxBlocking
import Combine
import RxSwift
import RxCocoa

class PublisherToObservableTests: XCTestCase {

    func test_PublisherToObservable_sequence() throws {
        let range = (1...10)
        let publisher = range.publisher
        let observable = publisher.asObservable()

        let expected = Array(range)
        let result = try observable.toBlocking().toArray()

        XCTAssertEqual(expected, result)
    }

    func test_PublisherToObservable_error() throws {
        let range = (1...10)
        let publisher = range.publisher
            .setFailureType(to: RxError.self)
            .tryMap { _ -> Int in
                throw RxError.noElements
            }
        let observable = publisher.asObservable()

        XCTAssertThrowsError(try observable.toBlocking().toArray()) {
            XCTAssertEqual(RxError.noElements.debugDescription, ($0 as! RxError).debugDescription)
        }
    }

    func test_PublisherToInfallible_sequence() throws {
        let range = (1...10)
        let publisher = range.publisher
        let observable = publisher.asInfallible()

        let expected = Array(range)
        let result = try observable.toBlocking().toArray()

        XCTAssertEqual(expected, result)
    }
}
