//
//  CALayer+Animation.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 21.07.2023.
//

import UIKit
import AsyncDisplayKit

// swiftlint:disable all
public extension CALayer {
    struct VASpring {
        let initialVelocity: CGFloat
        let damping: CGFloat
        let mass: CGFloat
        let swiftness: CGFloat

        public init(initialVelocity: CGFloat = 0, damping: CGFloat = 100, mass: CGFloat = 2, swiftness: CGFloat = 100) {
            self.initialVelocity = initialVelocity
            self.damping = damping
            self.mass = mass
            self.swiftness = swiftness
        }
    }

    enum VAAnimation {
        case anchor(from: CGPoint, to: CGPoint)
        case backgroundColor(from: UIColor, to: UIColor)
        case borderColor(from: UIColor, to: UIColor)
        case borderWidth(from: CGFloat, to: CGFloat)
        case cornerRadius(from: CGFloat, to: CGFloat)
        case opacity(from: CGFloat, to: CGFloat)
        case scale(from: CGFloat, to: CGFloat)
        case scaleX(from: CGFloat, to: CGFloat)
        case scaleY(from: CGFloat, to: CGFloat)
        case shadowColor(from: UIColor, to: UIColor)
        case shadowOpacity(from: CGFloat, to: CGFloat)
        case shadowOffset(from: CGSize, to: CGSize)
        case shadowRadius(from: CGFloat, to: CGFloat)
        case position(from: CGPoint, to: CGPoint)
        case positionX(from: CGFloat, to: CGFloat)
        case positionY(from: CGFloat, to: CGFloat)
        case bounds(from: CGRect, to: CGRect)
        case originX(from: CGFloat, to: CGFloat)
        case originY(from: CGFloat, to: CGFloat)
        case width(from: CGFloat, to: CGFloat)
        case height(from: CGFloat, to: CGFloat)
        case rotation(from: CGFloat, to: CGFloat)
        case locations(from: [CGFloat], to: [CGFloat])
        case colors(from: [UIColor], to: [UIColor])
        case startPoint(from: CGPoint, to: CGPoint)
        case endPoint(from: CGPoint, to: CGPoint)

        var keyPath: String {
            switch self {
            case .anchor: return "anchorPoint"
            case .backgroundColor: return "backgroundColor"
            case .borderColor: return "borderColor"
            case .borderWidth: return "borderWidth"
            case .bounds: return "bounds"
            case .colors: return "colors"
            case .cornerRadius: return "cornerRadius"
            case .originX: return "bounds.origin.x"
            case .originY: return "bounds.origin.y"
            case .width: return "bounds.size.width"
            case .height: return "bounds.size.height"
            case .locations: return "locations"
            case .position: return "position"
            case .positionX: return "position.x"
            case .positionY: return "position.y"
            case .opacity: return "opacity"
            case .scale: return "transform.scale"
            case .scaleX: return "transform.scale.x"
            case .scaleY: return "transform.scale.y"
            case .shadowColor: return "shadowColor"
            case .shadowOpacity: return "shadowOpacity"
            case .shadowOffset: return "shadowOffset"
            case .shadowRadius: return "shadowRadius"
            case .rotation: return "transform.rotation.z"
            case .startPoint: return "startPoint"
            case .endPoint: return "endPoint"
            }
        }
        var isToEqualsFrom: Bool {
            switch self {
            case let .anchor(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .backgroundColor(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .borderColor(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .borderWidth(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .bounds(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .colors(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .cornerRadius(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .originX(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .originY(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .width(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .height(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .locations(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .position(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .positionX(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .positionY(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .opacity(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .scale(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .scaleX(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .scaleY(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .shadowColor(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .shadowOpacity(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .shadowOffset(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .shadowRadius(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .rotation(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .startPoint(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .endPoint(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible):
                return from.getIsEqual(to: to)
            }
        }
        var values: (from: Any?, to: Any?) {
            switch self {
            case let .anchor(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .backgroundColor(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .borderColor(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .borderWidth(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .bounds(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .colors(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .cornerRadius(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .originX(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .originY(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .width(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .height(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .locations(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .position(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .positionX(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .positionY(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .opacity(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .scale(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .scaleX(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .scaleY(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .shadowColor(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .shadowOpacity(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .shadowOffset(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .shadowRadius(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .rotation(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .startPoint(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .endPoint(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible):
                return (from.animationValue, to.animationValue)
            }
        }

        func getProgressMultiplier(current: Any?) -> Double {
            switch self {
            case let .anchor(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .backgroundColor(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .borderColor(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .borderWidth(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .bounds(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .colors(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .cornerRadius(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .originX(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .originY(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .width(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .height(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .locations(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .position(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .positionX(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .positionY(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .opacity(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .scale(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .scaleX(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .scaleY(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .shadowColor(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .shadowOpacity(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .shadowOffset(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .shadowRadius(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .rotation(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .startPoint(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible),
                let .endPoint(from as VALayerAnimationValueConvertible, to as VALayerAnimationValueConvertible):
                return from.getProgressMultiplier(to: to, current: current)
            }
        }
    }

    @discardableResult
    func add(
        animation: VAAnimation,
        duration: Double,
        delay: Double = 0.0,
        timeOffset: Double = 0.0,
        repeatCount: Float = 0.0,
        timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        autoreverses: Bool = false,
        additive: Bool = false,
        continueFromCurrent: Bool = false,
        force: Bool = false,
        spring: VASpring? = nil,
        completion: ((Bool) -> Void)? = nil
    ) -> Self {
        if animation.isToEqualsFrom && !force {
            completion?(true)
            return self
        }
        let basicAnimation = getAnimation(
            animation,
            duration: duration,
            delay: delay,
            timeOffset: timeOffset,
            repeatCount: repeatCount,
            timingFunction: timingFunction,
            mediaTimingFunction: mediaTimingFunction,
            removeOnCompletion: removeOnCompletion,
            additive: additive,
            continueFromCurrent: continueFromCurrent,
            force: force,
            spring: spring,
            completion: completion
        )
        add(basicAnimation, forKey: additive ? nil : animation.keyPath)
        return self
    }

    func getAnimation(
        _ animation: VAAnimation,
        duration: Double,
        delay: Double = 0.0,
        timeOffset: Double = 0.0,
        repeatCount: Float = 0.0,
        timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        autoreverses: Bool = false,
        additive: Bool = false,
        continueFromCurrent: Bool = false,
        force: Bool = false,
        spring: VASpring? = nil,
        completion: ((Bool) -> Void)? = nil
    ) -> CABasicAnimation {
#if DEBUG
        switch animation {
        case .locations, .colors, .startPoint, .endPoint:
            assert(self is CAGradientLayer)
        default:
            break
        }
#endif
        var duration = duration
        var (from, to) = animation.values
        if delay.isZero, continueFromCurrent, let value = presentation()?.value(forKeyPath: animation.keyPath) {
            let progress = animation.getProgressMultiplier(current: value)
            duration *= progress
            from = value
            print(progress, duration, from)
        }
        return getAnimation(
            from: from,
            to: to,
            keyPath: animation.keyPath,
            duration: duration,
            delay: delay,
            timeOffset: timeOffset,
            repeatCount: repeatCount,
            timingFunction: timingFunction,
            mediaTimingFunction: mediaTimingFunction,
            removeOnCompletion: removeOnCompletion,
            autoreverses: autoreverses,
            additive: additive,
            spring: spring,
            completion: completion
        )
    }

    enum VAKeyFrameAnimation {
        case scale(values: [CGFloat])
        case positionX(values: [CGFloat])
        case positionY(values: [CGFloat])
        case opacity(values: [CGFloat])

        var keyPath: String {
            switch self {
            case .opacity: return "opacity"
            case .positionX: return "position.x"
            case .positionY: return "position.y"
            case .scale: return "transform.scale"
            }
        }
    }

    @discardableResult
    func add(
        animation: VAKeyFrameAnimation,
        duration: Double,
        delay: Double = 0.0,
        timeOffset: Double = 0.0,
        repeatCount: Float = 0.0,
        timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        autoreverses: Bool = false,
        additive: Bool = false,
        completion: ((Bool) -> Void)? = nil
    ) -> Self {
        let kfAnimation = getAnimation(
            animation,
            duration: duration,
            delay: delay,
            timeOffset: timeOffset,
            repeatCount: repeatCount,
            timingFunction: timingFunction,
            mediaTimingFunction: mediaTimingFunction,
            removeOnCompletion: removeOnCompletion,
            autoreverses: autoreverses,
            additive: additive,
            completion: completion
        )
        add(kfAnimation, forKey: additive ? nil : animation.keyPath)
        return self
    }

    func getAnimation(
        _ animation: VAKeyFrameAnimation,
        duration: Double,
        delay: Double = 0.0,
        timeOffset: Double = 0.0,
        repeatCount: Float = 0.0,
        timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        autoreverses: Bool = false,
        additive: Bool = false,
        completion: ((Bool) -> Void)? = nil
    ) -> CAKeyframeAnimation {
        let kfAnimation: CAKeyframeAnimation
        switch animation {
        case let .scale(values),
            let .positionX(values),
            let .positionY(values),
            let .opacity(values):
            kfAnimation = getAnimation(
                keyFrames: values,
                duration: duration,
                delay: delay,
                timeOffset: timeOffset,
                repeatCount: repeatCount,
                keyPath: animation.keyPath,
                timingFunction: timingFunction,
                mediaTimingFunction: mediaTimingFunction,
                removeOnCompletion: removeOnCompletion,
                autoreverses: autoreverses,
                additive: additive,
                completion: completion
            )
        }
        return kfAnimation
    }

    private func getAnimation(
        keyFrames: [Any],
        duration: Double,
        delay: Double,
        timeOffset: Double,
        repeatCount: Float,
        keyPath: String,
        timingFunction: CAMediaTimingFunctionName,
        mediaTimingFunction: CAMediaTimingFunction?,
        removeOnCompletion: Bool,
        autoreverses: Bool,
        additive: Bool,
        completion: ((Bool) -> Void)?
    ) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.values = keyFrames
        var keyTimes: [NSNumber] = []
        for i in keyFrames.indices {
            if i == 0 {
                keyTimes.append(0.0)
            } else if i == keyFrames.count - 1 {
                keyTimes.append(1.0)
            } else {
                keyTimes.append(NSNumber(value: (Double(i) / Double(keyFrames.count - 1))))
            }
        }
        animation.keyTimes = keyTimes
        animation.duration = duration
        if !delay.isZero {
            animation.beginTime = convertTime(CACurrentMediaTime(), from: nil) + delay
            animation.fillMode = .both
        }
        animation.timeOffset = timeOffset
        animation.repeatCount = repeatCount
        if let mediaTimingFunction = mediaTimingFunction {
            animation.timingFunction = mediaTimingFunction
        } else {
            animation.timingFunction = CAMediaTimingFunction(name: timingFunction)
        }
        animation.isRemovedOnCompletion = removeOnCompletion
        animation.autoreverses = autoreverses
        animation.isAdditive = additive
        if let completion {
            animation.delegate = _AnimationDelegate(animation: animation, completion: completion)
        }
        return animation
    }

    private func animate(
        from: Any?,
        to: Any,
        keyPath: String,
        duration: Double,
        delay: Double,
        timeOffset: Double,
        repeatCount: Float,
        timingFunction: CAMediaTimingFunctionName,
        mediaTimingFunction: CAMediaTimingFunction?,
        removeOnCompletion: Bool,
        autoreverses: Bool,
        additive: Bool,
        spring: VASpring?,
        completion: ((Bool) -> Void)?
    ) {
        let animation = getAnimation(
            from: from,
            to: to,
            keyPath: keyPath,
            duration: duration,
            delay: delay,
            timeOffset: timeOffset,
            repeatCount: repeatCount,
            timingFunction: timingFunction,
            mediaTimingFunction: mediaTimingFunction,
            removeOnCompletion: removeOnCompletion,
            autoreverses: autoreverses,
            additive: additive,
            spring: spring,
            completion: completion
        )
        add(animation, forKey: additive ? nil : keyPath)
    }

    private func getAnimation(
        from: Any?,
        to: Any,
        keyPath: String,
        duration: Double,
        delay: Double,
        timeOffset: Double,
        repeatCount: Float,
        timingFunction: CAMediaTimingFunctionName,
        mediaTimingFunction: CAMediaTimingFunction?,
        removeOnCompletion: Bool,
        autoreverses: Bool,
        additive: Bool,
        spring: VASpring?,
        completion: ((Bool) -> Void)?
    ) -> CABasicAnimation {
        let animation: CABasicAnimation
        if let spring {
            let springAnimation = CASpringAnimation(keyPath: keyPath)
            springAnimation.mass = spring.mass
            springAnimation.stiffness = spring.swiftness
            springAnimation.damping = spring.damping
            springAnimation.initialVelocity = spring.initialVelocity
            animation = springAnimation
        } else {
            animation = CABasicAnimation(keyPath: keyPath)
        }
        animation.fromValue = from
        animation.toValue = to
        if let anim = animation as? CASpringAnimation {
            animation.duration = anim.settlingDuration
        } else {
            animation.duration = duration
        }
        if !delay.isZero {
            animation.beginTime = convertTime(CACurrentMediaTime(), from: nil) + delay
            animation.fillMode = .both
        }
        if let mediaTimingFunction {
            animation.timingFunction = mediaTimingFunction
        } else {
            animation.timingFunction = CAMediaTimingFunction(name: timingFunction)
        }
        animation.timeOffset = timeOffset
        animation.repeatCount = repeatCount
        animation.isRemovedOnCompletion = removeOnCompletion
        animation.autoreverses = autoreverses
        animation.fillMode = .forwards
        animation.isAdditive = additive
        if let completion {
            animation.delegate = _AnimationDelegate(animation: animation, completion: completion)
        }
        return animation
    }

    @discardableResult
    func animate(chain animations: [CAAnimation], key: String = UUID().uuidString, completion: ((Bool) -> Void)? = nil) -> Self {
        let animationGroup = CAAnimationGroup()
        var duration = 0.0
        for animation in animations {
            animation.beginTime = convertTime(animation.beginTime, from: nil) + duration
            duration += animation.duration
        }
        animationGroup.animations = animations
        animationGroup.duration = duration
        if let completion {
            animationGroup.delegate = _AnimationDelegate(animation: animationGroup, completion: completion)
        }
        add(animationGroup, forKey: key)
        return self
    }

    @discardableResult
    func animate(group animations: [CAAnimation], duration: TimeInterval, key: String = UUID().uuidString, removeOnCompletion: Bool = false, completion: ((Bool) -> Void)? = nil) -> Self {
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = animations
        
        animationGroup.duration = duration
        animationGroup.isRemovedOnCompletion = removeOnCompletion
        if let completion {
            animationGroup.delegate = _AnimationDelegate(animation: animationGroup, completion: completion)
        }
        add(animationGroup, forKey: key)
        return self
    }

    var isAnimationsPaused: Bool { speed.isZero }

    func pauseAnimations() {
        if !isAnimationsPaused {
            let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
            speed = 0.0
            timeOffset = pausedTime
        }
    }

    func resumeAnimations() {
        if isAnimationsPaused {
            let pausedTime = timeOffset
            speed = 1.0
            timeOffset = 0.0
            beginTime = 0.0
            let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            beginTime = timeSincePause
        }
    }

    var hasAnimations: Bool { animationKeys().map { !$0.isEmpty } ?? false }
}

@objc private class _AnimationDelegate: NSObject, CAAnimationDelegate {
    private(set) var completion: ((Bool) -> Void)?
    private(set) var keyPath: String?

    init(animation: CAAnimation, completion: ((Bool) -> Void)?) {
        if let animation = animation as? CABasicAnimation {
            self.keyPath = animation.keyPath
        }
        self.completion = completion

        super.init()
    }

    @objc func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let animation = anim as? CABasicAnimation {
            if animation.keyPath != keyPath {
                return
            }
        }
        if let completion {
            completion(flag)
            self.completion = nil
        }
    }
}

protocol VALayerAnimationValueConvertible {
    var animationValue: Any? { get }

    func getIsEqual(to: Any?) -> Bool
    func getProgressMultiplier(to: Any?, current: Any?) -> Double
}

extension CGFloat: VALayerAnimationValueConvertible {
    var animationValue: Any? { self as NSNumber }

    func getIsEqual(to: Any?) -> Bool {
        guard let to = to as? CGFloat else {
            return false
        }
        return to == self
    }

    func getProgressMultiplier(to: Any?, current: Any?) -> Double {
        guard let to = to as? CGFloat else {
            return 0
        }
        return getProgress(toComponent: to, currentComponent: (current as? CGFloat) ?? self)
    }

    func getProgress(toComponent: CGFloat, currentComponent: CGFloat) -> Double {
        let fullPath = toComponent - self
        guard !fullPath.isZero else {
            return 0
        }
        let currentPath = toComponent - currentComponent
        return currentPath.getProgress(total: fullPath)
    }

    private func getProgress(total: CGFloat) -> Double {
        let progress = self / total
        if progress.isNaN || progress.isInfinite {
            return 0
        } else {
            return Swift.max(0, Swift.min(1, abs(progress)))
        }
    }
}

extension CGPoint: VALayerAnimationValueConvertible {
    var animationValue: Any? { NSValue(cgPoint: self) }

    func getIsEqual(to: Any?) -> Bool {
        guard let to = to as? CGPoint else {
            return false
        }
        return to == self
    }

    func getProgressMultiplier(to: Any?, current: Any?) -> Double {
        guard let to = to as? CGPoint else {
            return 0
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
    var animationValue: Any? { NSValue(cgRect: self) }

    func getIsEqual(to: Any?) -> Bool {
        guard let to = to as? CGRect else {
            return false
        }
        return to == self
    }

    func getProgressMultiplier(to: Any?, current: Any?) -> Double {
        guard let to = to as? CGRect else {
            return 0
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
    var animationValue: Any? { NSValue(cgSize: self) }

    func getIsEqual(to: Any?) -> Bool {
        guard let to = to as? CGSize else {
            return false
        }
        return to == self
    }

    func getProgressMultiplier(to: Any?, current: Any?) -> Double {
        guard let to = to as? CGSize else {
            return 0
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
    var animationValue: Any? { cgColor }

    func getIsEqual(to: Any?) -> Bool {
        guard let to = to as? UIColor else {
            return false
        }
        return to == self
    }

    func getProgressMultiplier(to: Any?, current: Any?) -> Double {
        guard let to = (to as? UIColor)?.rgba else {
            return 0
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

extension Array: VALayerAnimationValueConvertible where Element: VALayerAnimationValueConvertible & Equatable {
    var animationValue: Any? { map(\.animationValue) }

    func getIsEqual(to: Any?) -> Bool {
        guard let to = to as? [Element] else {
            return false
        }
        return to == self
    }

    func getProgressMultiplier(to: Any?, current: Any?) -> Double {
        guard let to = to as? [VALayerAnimationValueConvertible] else {
            return 0
        }
        let current = (current as? [VALayerAnimationValueConvertible]) ?? self
        var progressArr: [Double] = []
        for (i, color) in self.enumerated() {
            if to.indices ~= i && current.indices ~= i {
                progressArr.append(color.getProgressMultiplier(to: to[i], current: current[i]))
            }
        }
        return progressArr.reduce(0.0, +) / Double(progressArr.count)
    }
}
