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

@MainActor
extension XCTestCase {
    enum SnapshotSize {
        case fixed(CGSize)
        case freeHeightFixedWidth(CGFloat)
        case freeWidthFixedHeight(CGFloat)
        case auto

        static let iPhone8: SnapshotSize = .fixed(CGSize(width: 375, height: 667))
        static let iPhone8HalfHeight: SnapshotSize = .fixed(CGSize(width: 375, height: 333))

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
        controller: ASDKViewController<ASDisplayNode>? = nil,
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
        delay: TimeInterval = 1 / 20,
        drawHierarchyInKeyWindow: Bool = false
    ) {
        assertNodeSnapshot(
            matching: value,
            controller: controller,
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
            delay: delay,
            drawHierarchyInKeyWindow: drawHierarchyInKeyWindow
        )
    }

    func assertNodeSnapshot(
        matching value: ASDisplayNode,
        controller: ASDKViewController<ASDisplayNode>? = nil,
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
        delay: TimeInterval = 1 / 20,
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
        func refreshLayout() {
            let sizeThatFits = sut.layoutThatFits(ASSizeRange(
                min: CGSize(width: widthRange.lowerBound, height: heightRange.lowerBound),
                max: CGSize(width: widthRange.upperBound, height: heightRange.upperBound)
            )).size
            sut.bounds = CGRect(origin: .zero, size: sizeThatFits)
            sut.loadForSnapshot()
        }
        refreshLayout()
        let expect = expectation(description: "snapshot")
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { // Crutch for image nodes and lists
            refreshLayout()
            DispatchQueue.main.async {
                if let controller {
                    assertSnapshot(
                        matching: controller,
                        as: .image(
                            on: .init(
                                safeArea: UIEdgeInsets(top: 44, bottom: 34),
                                size: CGSize(width: widthRange.upperBound, height: heightRange.upperBound),
                                traits: .init()
                            ),
                            precision: precision,
                            perceptualPrecision: perceptualPrecision,
                            size: CGSize(width: widthRange.upperBound, height: heightRange.upperBound),
                            traits: .init()
                        ),
                        named: additions,
                        record: recording,
                        file: file,
                        testName: testName,
                        line: line
                    )
                } else {
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
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 1 + delay * 2)
    }

    func assertControllerSnapshot(
        matching sut: ASDKViewController<ASDisplayNode>,
        size: CGSize = CGSize(width: 375, height: 812),
        named name: String? = nil,
        record recording: Bool = false,
        timeout: TimeInterval = 5,
        file: StaticString = #file,
        testName: String = #function,
        additions: String? = nil,
        line: UInt = #line,
        precision: Float = 0.995,
        perceptualPrecision: Float = 0.99,
        delay: TimeInterval = 1 / 20
    ) {
        sut.loadViewIfNeeded()
        sut.view.frame = CGRect(origin: .zero, size: size)
        sut.view.setNeedsLayout()
        sut.view.layoutIfNeeded()
        assertNodeSnapshot(
            matching: sut.node,
            controller: sut,
            size: .fixed(size),
            named: name,
            record: recording,
            timeout: timeout,
            file: file,
            testName: testName,
            additions: additions,
            line: line,
            precision: precision,
            perceptualPrecision: perceptualPrecision,
            drawHierarchyInKeyWindow: false
        )
    }
}
