//
//  Support+Snapshots.swift
//  MoviesExample
//
//  Created by VAndrJ on 15.04.2023.
//

import VATextureKit
import SnapshotTesting
import XCTest
@testable import MoviesExample

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
        delay: TimeInterval = 1 / 30
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
            delay: delay
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
        delay: TimeInterval = 1 / 30
    ) {
        let sut: ASDisplayNode
        if value.isLayerBacked {
            sut = ASDisplayNode()
            sut.addSubnode(value)
            sut.layoutSpecBlock = { _, _ in value.wrapped() }
        } else {
            sut = value
        }
        sut.view.setNeedsLayout()
        sut.view.setNeedsDisplay()
        sut.view.layoutIfNeeded()
        let sizeThatFits = sut.layoutThatFits(ASSizeRange(
            min: CGSize(width: widthRange.lowerBound, height: heightRange.lowerBound),
            max: CGSize(width: widthRange.upperBound, height: heightRange.upperBound)
        )).size
        sut.bounds = CGRect(origin: .zero, size: sizeThatFits)
        sut.loadForPreview()

        let expect = expectation(description: "snapshot")
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { // Crutch for image nodes
            sut.loadForPreview()
            DispatchQueue.main.async {
                assertSnapshot(
                    matching: sut.view,
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
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 1 + delay * 2)
    }
}
