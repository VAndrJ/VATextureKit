//
//  CALayer+Support.swift
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

        var keyPath: String {
            switch self {
            case .anchor: return "anchorPoint"
            case .backgroundColor: return "backgroundColor"
            case .borderColor: return "borderColor"
            case .borderWidth: return "borderWidth"
            case .bounds: return  "bounds"
            case .cornerRadius: return "cornerRadius"
            case .originX: return "bounds.origin.x"
            case .originY: return "bounds.origin.y"
            case .width: return "bounds.size.width"
            case .height: return "bounds.size.height"
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
            }
        }
    }

    @discardableResult
    func add(
        animation: VAAnimation,
        duration: Double,
        delay: Double = 0.0,
        timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        additive: Bool = false,
        continueFromCurrent: Bool = false,
        force: Bool = false,
        spring: VASpring? = nil,
        completion: ((Bool) -> Void)? = nil
    ) -> Self {
        switch animation {
        case let .shadowOpacity(from, to),
            let .shadowRadius(from, to),
            let .borderWidth(from, to),
            let .cornerRadius(from, to),
            let .scale(from, to),
            let .scaleX(from, to),
            let .scaleY(from, to),
            let .opacity(from, to),
            let .originX(from, to),
            let .originY(from, to),
            let .rotation(from, to),
            let .positionX(from, to),
            let .positionY(from, to),
            let .height(from, to),
            let .width(from, to):
            if from == to && !force {
                completion?(true)
                return self
            }
        case let .backgroundColor(from, to),
            let .borderColor(from, to),
            let .shadowColor(from, to):
            if from == to && !force {
                completion?(true)
                return self
            }
        case let .position(from, to),
            let .anchor(from, to):
            if from == to && !force {
                completion?(true)
                return self
            }
        case let .bounds(from, to):
            if from == to && !force {
                completion?(true)
                return self
            }
        case let .shadowOffset(from, to):
            if from == to && !force {
                completion?(true)
                return self
            }
        }
        let basicAnimation = getAnimation(
            animation,
            duration: duration,
            delay: delay,
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
        timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        additive: Bool = false,
        continueFromCurrent: Bool = false,
        force: Bool = false,
        spring: VASpring? = nil,
        completion: ((Bool) -> Void)? = nil
    ) -> CABasicAnimation {
        let basicAnimation: CABasicAnimation
        switch animation {
        case let .shadowOpacity(from, to),
            let .shadowRadius(from, to),
            let .borderWidth(from, to),
            let .cornerRadius(from, to),
            let .scale(from, to),
            let .scaleX(from, to),
            let .scaleY(from, to),
            let .opacity(from, to),
            let .originX(from, to),
            let .originY(from, to),
            let .rotation(from, to),
            let .positionX(from, to),
            let .positionY(from, to),
            let .height(from, to),
            let .width(from, to):
            var duration = duration
            var from = from
            if delay.isZero, continueFromCurrent, let value = presentation()?.value(forKeyPath: animation.keyPath) as? CGFloat {
                let multiplier = (to - value) / (to - from)
                duration *= multiplier
                from = value
            }
            basicAnimation = getAnimation(
                from: NSNumber(value: from),
                to: NSNumber(value: to),
                keyPath: animation.keyPath,
                duration: duration,
                delay: delay,
                timingFunction: timingFunction,
                mediaTimingFunction: mediaTimingFunction,
                removeOnCompletion: removeOnCompletion,
                additive: additive,
                spring: spring,
                completion: completion
            )
        case let .backgroundColor(from, to),
            let .borderColor(from, to),
            let .shadowColor(from, to):
            basicAnimation = getAnimation(
                from: from.cgColor,
                to: to.cgColor,
                keyPath: animation.keyPath,
                duration: duration,
                delay: delay,
                timingFunction: timingFunction,
                mediaTimingFunction: mediaTimingFunction,
                removeOnCompletion: removeOnCompletion,
                additive: additive,
                spring: spring,
                completion: completion
            )
        case let .position(from, to),
            let .anchor(from, to):
            basicAnimation = getAnimation(
                from: NSValue(cgPoint: from),
                to: NSValue(cgPoint: to),
                keyPath: animation.keyPath,
                duration: duration,
                delay: delay,
                timingFunction: timingFunction,
                mediaTimingFunction: mediaTimingFunction,
                removeOnCompletion: removeOnCompletion,
                additive: additive,
                spring: spring,
                completion: completion
            )
        case let .bounds(from, to):
            basicAnimation = getAnimation(
                from: NSValue(cgRect: from),
                to: NSValue(cgRect: to),
                keyPath: #keyPath(CALayer.bounds),
                duration: duration,
                delay: delay,
                timingFunction: timingFunction,
                mediaTimingFunction: mediaTimingFunction,
                removeOnCompletion: removeOnCompletion,
                additive: additive,
                spring: spring,
                completion: completion
            )
        case let .shadowOffset(from, to):
            basicAnimation = getAnimation(
                from: NSValue(cgSize: from),
                to: NSValue(cgSize: to),
                keyPath: #keyPath(CALayer.bounds),
                duration: duration,
                delay: delay,
                timingFunction: timingFunction,
                mediaTimingFunction: mediaTimingFunction,
                removeOnCompletion: removeOnCompletion,
                additive: additive,
                spring: spring,
                completion: completion
            )
        }
        return basicAnimation
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
        timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        additive: Bool = false,
        completion: ((Bool) -> Void)? = nil
    ) -> Self {
        let kfAnimation = getAnimation(
            animation,
            duration: duration,
            delay: delay,
            timingFunction: timingFunction,
            mediaTimingFunction: mediaTimingFunction,
            removeOnCompletion: removeOnCompletion,
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
        timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
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
                keyPath: animation.keyPath,
                timingFunction: timingFunction,
                mediaTimingFunction: mediaTimingFunction,
                removeOnCompletion: removeOnCompletion,
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
        keyPath: String,
        timingFunction: CAMediaTimingFunctionName,
        mediaTimingFunction: CAMediaTimingFunction?,
        removeOnCompletion: Bool,
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
        if let mediaTimingFunction = mediaTimingFunction {
            animation.timingFunction = mediaTimingFunction
        } else {
            animation.timingFunction = CAMediaTimingFunction(name: timingFunction)
        }
        animation.isRemovedOnCompletion = removeOnCompletion
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
        timingFunction: CAMediaTimingFunctionName,
        mediaTimingFunction: CAMediaTimingFunction?,
        removeOnCompletion: Bool,
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
            timingFunction: timingFunction,
            mediaTimingFunction: mediaTimingFunction,
            removeOnCompletion: removeOnCompletion,
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
        timingFunction: CAMediaTimingFunctionName,
        mediaTimingFunction: CAMediaTimingFunction?,
        removeOnCompletion: Bool,
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
        animation.isRemovedOnCompletion = removeOnCompletion
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
