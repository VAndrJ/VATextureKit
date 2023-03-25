//
//  Support.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 25.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
import RxSwift

extension XCTestCase {

    func spy<T>(_ observable: Observable<T>, timeout: TimeInterval = 10) -> ObservableSpy<T> {
        ObservableSpy(
            observable,
            expectation: { self.expectation(description: "Observable spy") },
            waiter: { self.wait(for: [$0], timeout: timeout) }
        )
    }
}

final class ObservableSpy<T> {
    private(set) var result: [T] = []

    private var disposable: Disposable?
    private var expectationFactory: () -> XCTestExpectation
    private var waiter: (XCTestExpectation) -> Void
    private var expectation: XCTestExpectation?

    init(
        _ observable: Observable<T>,
        expectation: @escaping () -> XCTestExpectation,
        waiter: @escaping (XCTestExpectation) -> Void
    ) {
        self.expectationFactory = expectation
        self.waiter = waiter

        disposable = observable
            .subscribe(onNext: { [weak self] in
                self?.result.append($0)
                self?.expectation?.fulfill()
                self?.expectation = nil
            })
    }

    func wait(_ expression: @escaping () -> Void) {
        let expectation = expectationFactory()
        self.expectation = expectation
        expression()
        waiter(expectation)
    }
}
