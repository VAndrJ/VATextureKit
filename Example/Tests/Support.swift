//
//  Support.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 25.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
import AsyncDisplayKit
import SnapshotTesting
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

extension XCTestCase {
    enum SnapshotSize {
        case fixed(CGSize)
        case freeHeightFixedWidth(CGFloat)
        case freeWidthFixedHeight(CGFloat)

        var widthRange: ClosedRange<CGFloat> {
            switch self {
            case let .fixed(size):
                return size.width...size.width
            case let .freeHeightFixedWidth(width):
                return width...width
            case .freeWidthFixedHeight:
                return CGFloat.leastNormalMagnitude...CGFloat.greatestFiniteMagnitude
            }
        }
        var heightRange: ClosedRange<CGFloat> {
            switch self {
            case let .fixed(size):
                return size.height...size.height
            case .freeHeightFixedWidth:
                return CGFloat.leastNormalMagnitude...CGFloat.greatestFiniteMagnitude
            case let .freeWidthFixedHeight(height):
                return height...height
            }
        }
    }

    func assertNodeSnapshot(
        matching value: ASDisplayNode,
        size: SnapshotSize,
        named name: String? = nil,
        record recording: Bool = false,
        timeout: TimeInterval = 5,
        file: StaticString = #file,
        testName: String = #function,
        additions: String? = nil,
        line: UInt = #line,
        precision: Float = 0.995,
        perceptualPrecision: Float = 0.99
    ) {
        assertNodeSnapshot(
            matching: value,
            widthRange: size.widthRange,
            heightRange: size.heightRange,
            named: name,
            record: recording,
            timeout: timeout,
            file: file,
            testName: testName,
            additions: additions,
            line: line,
            precision: precision,
            perceptualPrecision: perceptualPrecision
        )
    }

    func assertNodeSnapshot(
        matching value: ASDisplayNode,
        widthRange: ClosedRange<CGFloat>,
        heightRange: ClosedRange<CGFloat>,
        named name: String? = nil,
        record recording: Bool = false,
        timeout: TimeInterval = 5,
        file: StaticString = #file,
        testName: String = #function,
        additions: String? = nil,
        line: UInt = #line,
        precision: Float = 0.995,
        perceptualPrecision: Float = 0.99
    ) {
        let sizeThatFits = value.layoutThatFits(ASSizeRange(
            min: CGSize(width: widthRange.lowerBound, height: heightRange.lowerBound),
            max: CGSize(width: widthRange.upperBound, height: heightRange.upperBound)
        )).size
        value.bounds = CGRect(origin: .zero, size: sizeThatFits)
        value.loadForTesting()

        assertSnapshot(
            matching: value.view,
            as: .image(
                precision: precision,
                perceptualPrecision: perceptualPrecision
            ),
            named: additions,
            record: recording,
            file: file,
            testName: testName,
            line: line
        )
    }
}

extension ASDisplayNode {

    func loadForTesting() {
        if #available(iOS 13.0, *) {
            ASTraitCollectionPropagateDown(self, ASPrimitiveTraitCollectionFromUITraitCollection(UITraitCollection.current))
        }
        displaysAsynchronously = false
        ASDisplayNodePerformBlockOnEveryNode(nil, self, true) {
            $0.layer.setNeedsDisplay()
        }
        recursivelyEnsureDisplaySynchronously(true)
    }
}
