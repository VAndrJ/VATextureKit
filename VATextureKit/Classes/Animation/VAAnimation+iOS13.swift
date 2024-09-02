//
//  VAAnimation+iOS13.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 02.04.2023.
//

#if canImport(SwiftUI)
#if compiler(>=6.0)
public import SwiftUI
public import AsyncDisplayKit
#else
import SwiftUI
import AsyncDisplayKit
#endif

extension RelationValue where Value: VectorArithmetic {

    public func value(for full: Value) -> Value {
        switch self {
        case let .absolute(value):
            return value
        case let .relative(value):
            var result = full
            result.scale(by: value)

            return result
        }
    }
}

extension Progress {

    public func value<T: VectorArithmetic>(identity: T, transformed: T) -> T {
        var result = identity - transformed
        result.scale(by: progress)

        return transformed + result
    }

    public func value(identity: UIColor, transformed: UIColor) -> UIColor {
        let iRGBA = identity.rgba
        let tRGBA = transformed.rgba
        let identityAnimatable = AnimatablePair(
            AnimatablePair(iRGBA.red, iRGBA.green),
            AnimatablePair(iRGBA.blue, iRGBA.alpha)
        )
        let transformedAnimatable = AnimatablePair(
            AnimatablePair(tRGBA.red, tRGBA.green),
            AnimatablePair(tRGBA.blue, tRGBA.alpha)
        )
        var result = identityAnimatable - transformedAnimatable
        result.scale(by: progress)
        result += transformedAnimatable
        
        return .init(
            red: result.first.first,
            green: result.first.second,
            blue: result.second.first,
            alpha: result.second.second
        )
    }
}

public extension VATransition {

    @MainActor
    @inline(__always) @inlinable static func value<T: VectorArithmetic>(
        _ keyPath: ReferenceWritableKeyPath<Base, T>,
        _ transformed: T,
        default defaultValue: T? = nil
    ) -> VATransition {
        .init(keyPath) { progress, view, value in
            view[keyPath: keyPath] = progress.value(identity: defaultValue ?? value, transformed: transformed)
        }
    }

    @MainActor
    @inline(__always) @inlinable static func value(
        _ keyPath: ReferenceWritableKeyPath<Base, UIColor?>,
        _ transformed: UIColor,
        default defaultValue: UIColor? = nil
    ) -> VATransition {
        .init(keyPath) { progress, view, value in
            view[keyPath: keyPath] = value.map {
                progress.value(identity: defaultValue ?? $0, transformed: transformed)
            }
        }
    }

    @MainActor
    @inline(__always) @inlinable static func value(
        _ keyPath: ReferenceWritableKeyPath<Base, UIColor>,
        _ transformed: UIColor,
        default defaultValue: UIColor? = nil
    ) -> VATransition {
        .init(keyPath) { progress, view, value in
            view[keyPath: keyPath] = progress.value(identity: defaultValue ?? value, transformed: transformed)
        }
    }
}

extension VATransition where Base == ASDisplayNode {

    @MainActor
    public static func backgroundColor(_ color: UIColor) -> VATransition { .value(\.backgroundColor, color) }
}
#endif
