//
//  VALayerAnimationValueConvertible.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 27.07.2023.
//

import UIKit

public protocol VALayerAnimationValueConvertible {
    var animationValue: Any { get }

    func getIsEqual(to: Any?) -> Bool
    func getProgressMultiplier(to: Any?, current: Any?) -> Double
}

extension CGFloat: VALayerAnimationValueConvertible {
    public var animationValue: Any { self as NSNumber }

    public func getIsEqual(to: Any?) -> Bool {
        guard let to = to as? CGFloat else {
            return false
        }
        
        return to == self
    }

    public func getProgressMultiplier(to: Any?, current: Any?) -> Double {
        guard let to = to as? CGFloat else {
            return 0.0
        }

        return getProgress(toComponent: to, currentComponent: (current as? CGFloat) ?? self)
    }

    func getProgress(toComponent: CGFloat, currentComponent: CGFloat) -> Double {
        let fullPath = toComponent - self
        guard !fullPath.isZero else {
            return 0.0
        }

        let currentPath = toComponent - currentComponent

        return currentPath.getProgress(total: fullPath)
    }

    private func getProgress(total: CGFloat) -> Double {
        let progress = self / total
        if progress.isNaN || progress.isInfinite {
            return 0.0
        } else {
            return Swift.max(0, Swift.min(1, abs(progress)))
        }
    }
}

extension CGPoint: VALayerAnimationValueConvertible {
    public var animationValue: Any { NSValue(cgPoint: self) }

    public func getIsEqual(to: Any?) -> Bool {
        guard let to = to as? CGPoint else {
            return false
        }

        return to == self
    }

    public func getProgressMultiplier(to: Any?, current: Any?) -> Double {
        guard let to = to as? CGPoint else {
            return 0.0
        }

        let from = self
        let current = (current as? CGPoint) ?? from
        let progressArr = [
            from.x.getProgress(toComponent: to.x, currentComponent: current.x),
            from.y.getProgress(toComponent: to.y, currentComponent: current.y),
        ]

        return progressArr.reduce(0.0, +) / Double(progressArr.count)
    }
}

extension CGRect: VALayerAnimationValueConvertible {
    public var animationValue: Any { NSValue(cgRect: self) }

    public func getIsEqual(to: Any?) -> Bool {
        guard let to = to as? CGRect else {
            return false
        }

        return to == self
    }

    public func getProgressMultiplier(to: Any?, current: Any?) -> Double {
        guard let to = to as? CGRect else {
            return 0.0
        }

        let from = self
        let current = (current as? CGRect) ?? from
        let progressArr = [
            from.origin.getProgressMultiplier(to: to.origin, current: current.origin),
            from.size.getProgressMultiplier(to: to.size, current: current.size),
        ]

        return progressArr.reduce(0.0, +) / Double(progressArr.count)
    }
}

extension CGSize: VALayerAnimationValueConvertible {
    public var animationValue: Any { NSValue(cgSize: self) }

    public func getIsEqual(to: Any?) -> Bool {
        guard let to = to as? CGSize else {
            return false
        }

        return to == self
    }

    public func getProgressMultiplier(to: Any?, current: Any?) -> Double {
        guard let to = to as? CGSize else {
            return 0.0
        }

        let from = self
        let current = (current as? CGSize) ?? from
        let progressArr = [
            from.width.getProgress(toComponent: to.width, currentComponent: current.width),
            from.height.getProgress(toComponent: to.height, currentComponent: current.height),
        ]

        return progressArr.reduce(0.0, +) / Double(progressArr.count)
    }
}

extension UIColor: VALayerAnimationValueConvertible {
    public var animationValue: Any { cgColor }

    public func getIsEqual(to: Any?) -> Bool {
        guard let to = to as? UIColor else {
            return false
        }

        return to == self
    }

    public func getProgressMultiplier(to: Any?, current: Any?) -> Double {
        guard let to = (to as? UIColor)?.rgba else {
            return 0.0
        }

        let from = rgba
        let current = (current as? UIColor)?.rgba ?? from
        let progressArr = [
            from.red.getProgress(toComponent: to.red, currentComponent: current.red),
            from.green.getProgress(toComponent: to.green, currentComponent: current.green),
            from.blue.getProgress(toComponent: to.blue, currentComponent: current.blue),
            from.alpha.getProgress(toComponent: to.alpha, currentComponent: current.alpha),
        ]

        return progressArr.reduce(0.0, +) / Double(progressArr.count)
    }
}

extension CGPath: VALayerAnimationValueConvertible {
    public var animationValue: Any { self }

    public func getIsEqual(to: Any?) -> Bool {
        if let to, type(of: to) is CGPath.Type {
            return (to as! CGPath) == self
        } else {
            return false
        }
        // https://forums.swift.org/t/how-can-i-cast-any-to-cf-types/17071
//        if let to, to is CGPath { // Error: 'is' test is always true because 'CGPath' is a Core Foundation type
//            return (to as! CGPath) == self
//        } else {
//            return false
//        }
//        guard let to = to as? CGPath else { // Error: Conditional downcast to CoreFoundation type 'CGPath' will always succeed
//            return false
//        }
//        return to == self // Error: Cannot convert value of type 'Any?' to expected argument type 'CGPath'
    }

    public func getProgressMultiplier(to: Any?, current: Any?) -> Double {
        return 0.0
    }
}

extension UIBezierPath: VALayerAnimationValueConvertible {
    public var animationValue: Any { cgPath }

    public func getIsEqual(to: Any?) -> Bool {
        guard let to = to as? UIBezierPath else {
            return false
        }

        return cgPath == to.cgPath
    }

    public func getProgressMultiplier(to: Any?, current: Any?) -> Double {
        return 0.0
    }
}

extension Array: VALayerAnimationValueConvertible where Element: VALayerAnimationValueConvertible & Equatable {
    public var animationValue: Any { map(\.animationValue) }

    public func getIsEqual(to: Any?) -> Bool {
        guard let to = to as? [Element] else {
            return false
        }

        return to == self
    }

    public func getProgressMultiplier(to: Any?, current: Any?) -> Double {
        guard let to = to as? [any VALayerAnimationValueConvertible] else {
            return 0.0
        }

        let current = (current as? [any VALayerAnimationValueConvertible]) ?? self
        var progressArr: [Double] = []
        for (i, value) in self.enumerated() {
            if to.indices ~= i && current.indices ~= i {
                progressArr.append(value.getProgressMultiplier(to: to[i], current: current[i]))
            }
        }
        guard !progressArr.isEmpty else {
            return 0.0
        }

        return progressArr.reduce(0.0, +) / Double(progressArr.count)
    }
}
