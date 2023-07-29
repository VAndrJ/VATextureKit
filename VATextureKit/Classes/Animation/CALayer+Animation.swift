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

    struct VALayerAnimation {
        let from: Any?
        let to: Any?
        let fromOriginalValue: Any?
        let toOriginalValue: Any?
        let keyPath: String
        let isToEqualsFrom: Bool

        func getProgressMultiplier(current: Any?) -> Double {
            if let fromOriginalValue = fromOriginalValue as? VALayerAnimationValueConvertible {
                return fromOriginalValue.getProgressMultiplier(to: toOriginalValue, current: current)
            } else {
                return 0
            }
        }
    }

    @discardableResult
    func add(
        animation: VALayerAnimation,
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
            autoreverses: autoreverses,
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
        _ animation: VALayerAnimation,
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
        var duration = duration
        var from = animation.from
        if delay.isZero, continueFromCurrent, let value = presentation()?.value(forKeyPath: animation.keyPath) {
            let progress = animation.getProgressMultiplier(current: value)
            duration *= progress
            from = value
        }
        return getAnimation(
            from: from,
            to: animation.to,
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

    struct VALayerKeyFrameAnimation {
        let values: [Any]
        let keyPath: String
    }

    @discardableResult
    func add(
        animation: VALayerKeyFrameAnimation,
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
        _ animation: VALayerKeyFrameAnimation,
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
        getAnimation(
            keyFrames: animation.values,
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
