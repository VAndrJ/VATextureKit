//
//  Support.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 25.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import SnapshotTesting
import VATextureKitRx
import Combine
import RxSwift
import RxCocoa

extension XCTestCase {
    var theme: VATheme { appContext.themeManager.theme }

    func spy<T>(_ observable: Observable<T>, timeout: TimeInterval = 10) -> ObservableSpy<T> {
        ObservableSpy(
            observable,
            expectation: { self.expectation(description: "Observable spy") },
            waiter: { self.wait(for: [$0], timeout: timeout) }
        )
    }

    func spy<T, Failure: Error>(_ publisher: AnyPublisher<T, Failure>, timeout: TimeInterval = 10) -> CombineSpy<T, Failure> {
        CombineSpy(
            publisher,
            expectation: { self.expectation(description: "AnyPublisher spy") },
            waiter: { self.wait(for: [$0], timeout: timeout) }
        )
    }
}

final class CombineSpy<T, Failure: Error> {
    private(set) var result: [T] = []
    private(set) var failure: Failure?
    private(set) var isCompleted = false

    private var cancellable: AnyCancellable?
    private var expectationFactory: () -> XCTestExpectation
    private var waiter: (XCTestExpectation) -> Void
    private var expectation: XCTestExpectation?

    init(
        _ observable: AnyPublisher<T, Failure>,
        expectation: @escaping () -> XCTestExpectation,
        waiter: @escaping (XCTestExpectation) -> Void
    ) {
        self.expectationFactory = expectation
        self.waiter = waiter

        cancellable = observable
            .sink(
                receiveCompletion: { [weak self] in
                    switch $0 {
                    case .finished:
                        self?.isCompleted = true
                    case let .failure(failure):
                        self?.failure = failure
                    }
                },
                receiveValue: { [weak self] in
                    self?.result.append($0)
                    self?.expectation?.fulfill()
                    self?.expectation = nil
                }
            )
    }

    func wait(_ expression: @escaping () -> Void) {
        let expectation = expectationFactory()
        self.expectation = expectation
        expression()
        waiter(expectation)
    }
}

final class ObservableSpy<T> {
    private(set) var result: [T] = []

    private var disposable: (any Disposable)?
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
        case auto

        var widthRange: ClosedRange<CGFloat> {
            switch self {
            case let .fixed(size):
                return size.width...size.width
            case let .freeHeightFixedWidth(width):
                return width...width
            case .freeWidthFixedHeight:
                return CGFloat.leastNormalMagnitude...CGFloat.greatestFiniteMagnitude
            case .auto:
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
            case .auto:
                return CGFloat.leastNormalMagnitude...CGFloat.greatestFiniteMagnitude
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
        perceptualPrecision: Float = 0.99,
        drawHierarchyInKeyWindow: Bool = false
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
            perceptualPrecision: perceptualPrecision,
            drawHierarchyInKeyWindow: drawHierarchyInKeyWindow
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
        perceptualPrecision: Float = 0.99,
        drawHierarchyInKeyWindow: Bool = false
    ) {
        let sut: ASDisplayNode
        if value.isLayerBacked {
            sut = ASDisplayNode()
            sut.addSubnode(value)
            sut.layoutSpecBlock = { _, _ in value.wrapped() }
        } else {
            sut = value
        }
        sut.loadForSnapshot()
        let sizeThatFits = sut.layoutThatFits(ASSizeRange(
            min: .init(width: widthRange.lowerBound, height: heightRange.lowerBound),
            max: .init(width: widthRange.upperBound, height: heightRange.upperBound)
        )).size
        if sizeThatFits == .zero {
            sut.layout()
            sut.bounds = .init(size: sut.style.preferredSize)
        } else {
            sut.bounds = .init(origin: .zero, size: sizeThatFits)
        }
        sut.loadForPreview()

        assertSnapshot(
            matching: sut.view,
            as: .image(
                drawHierarchyInKeyWindow: drawHierarchyInKeyWindow,
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

extension AppNavigator {
    static let dummy = AppNavigator(
        window: UIWindow(),
        screenFactory: AppScreenFactory(themeManager: ThemeManager()),
        navigationInterceptor: nil
    )
}

class MockTapReceiver {
    var isTapped = false
}

enum MockError1: Error, Equatable {
    case mock1Error
}

extension MockError1 {
    var mapped: MockError2 {
        switch self {
        case .mock1Error: .mock2Error
        }
    }
}

enum MockError2: Error, Equatable {
    case mock2Error
}
