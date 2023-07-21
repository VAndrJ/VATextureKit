//
//  CALayer+Support.swift
//  VATextureKit
//
//  Created by VAndrJ on 21.07.2023.
//

import UIKit
import AsyncDisplayKit

// swiftlint:disable all
public extension CALayer {
    enum VAAnimation {
        case opacity(
            from: CGFloat,
            to: CGFloat,
            duration: Double,
            delay: Double = 0.0,
            timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
            mediaTimingFunction: CAMediaTimingFunction? = nil,
            removeOnCompletion: Bool = true,
            additive: Bool = false,
            completion: ((Bool) -> Void)? = nil
        )
        case scale(
            from: CGFloat,
            to: CGFloat,
            duration: Double,
            delay: Double = 0.0,
            timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
            mediaTimingFunction: CAMediaTimingFunction? = nil,
            removeOnCompletion: Bool = true,
            additive: Bool = false,
            completion: ((Bool) -> Void)? = nil
        )
        case scaleX(
            from: CGFloat,
            to: CGFloat,
            duration: Double,
            delay: Double = 0.0,
            timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
            mediaTimingFunction: CAMediaTimingFunction? = nil,
            removeOnCompletion: Bool = true,
            additive: Bool = false,
            completion: ((Bool) -> Void)? = nil
        )
        case scaleY(
            from: CGFloat,
            to: CGFloat,
            duration: Double,
            delay: Double = 0.0,
            timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
            mediaTimingFunction: CAMediaTimingFunction? = nil,
            removeOnCompletion: Bool = true,
            additive: Bool = false,
            completion: ((Bool) -> Void)? = nil
        )
        case position(
            from: CGPoint,
            to: CGPoint,
            duration: Double,
            delay: Double = 0.0,
            timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
            mediaTimingFunction: CAMediaTimingFunction? = nil,
            removeOnCompletion: Bool = true,
            additive: Bool = false,
            force: Bool = false,
            completion: ((Bool) -> Void)? = nil
        )
        case positionX(
            from: CGFloat,
            to: CGFloat,
            duration: Double,
            delay: Double = 0.0,
            timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
            mediaTimingFunction: CAMediaTimingFunction? = nil,
            removeOnCompletion: Bool = true,
            additive: Bool = false,
            force: Bool = false,
            completion: ((Bool) -> Void)? = nil
        )
        case positionY(
            from: CGFloat,
            to: CGFloat,
            duration: Double,
            delay: Double = 0.0,
            timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
            mediaTimingFunction: CAMediaTimingFunction? = nil,
            removeOnCompletion: Bool = true,
            additive: Bool = false,
            force: Bool = false,
            completion: ((Bool) -> Void)? = nil
        )
        case bounds(
            from: CGRect,
            to: CGRect,
            duration: Double,
            delay: Double = 0.0,
            timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
            mediaTimingFunction: CAMediaTimingFunction? = nil,
            removeOnCompletion: Bool = true,
            additive: Bool = false,
            force: Bool = false,
            completion: ((Bool) -> Void)? = nil
        )
        case originX(
            from: CGFloat,
            to: CGFloat,
            duration: Double,
            delay: Double = 0.0,
            timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
            mediaTimingFunction: CAMediaTimingFunction? = nil,
            removeOnCompletion: Bool = true,
            additive: Bool = false,
            completion: ((Bool) -> Void)? = nil
        )
        case originY(
            from: CGFloat,
            to: CGFloat,
            duration: Double,
            delay: Double = 0.0,
            timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
            mediaTimingFunction: CAMediaTimingFunction? = nil,
            removeOnCompletion: Bool = true,
            additive: Bool = false,
            completion: ((Bool) -> Void)? = nil
        )
        case width(
            from: CGFloat,
            to: CGFloat,
            duration: Double,
            delay: Double = 0.0,
            timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
            mediaTimingFunction: CAMediaTimingFunction? = nil,
            removeOnCompletion: Bool = true,
            additive: Bool = false,
            force: Bool = false,
            completion: ((Bool) -> Void)? = nil
        )
        case height(
            from: CGFloat,
            to: CGFloat,
            duration: Double,
            delay: Double = 0.0,
            timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
            mediaTimingFunction: CAMediaTimingFunction? = nil,
            removeOnCompletion: Bool = true,
            additive: Bool = false,
            force: Bool = false,
            completion: ((Bool) -> Void)? = nil
        )
        case anchor(
            from: CGPoint,
            to: CGPoint,
            duration: Double,
            delay: Double = 0.0,
            timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
            mediaTimingFunction: CAMediaTimingFunction? = nil,
            removeOnCompletion: Bool = true,
            additive: Bool = false,
            force: Bool = false,
            completion: ((Bool) -> Void)? = nil
        )
        case rotation(
            from: CGFloat,
            to: CGFloat,
            duration: Double,
            delay: Double = 0.0,
            timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
            mediaTimingFunction: CAMediaTimingFunction? = nil,
            removeOnCompletion: Bool = true,
            additive: Bool = false,
            completion: ((Bool) -> Void)? = nil
        )

        var keyPath: String {
            switch self {
            case .anchor: return "anchorPoint"
            case .bounds: return  "bounds"
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
            case .rotation: return "transform.rotation.z"
            }
        }
    }

    @discardableResult
    func add(animation: VAAnimation) -> Self {
        switch animation {
        case let .scale(from, to, duration, delay, timingFunction, mediaTimingFunction, removeOnCompletion, additive, completion),
            let .scaleX(from, to, duration, delay, timingFunction, mediaTimingFunction, removeOnCompletion, additive, completion),
            let .scaleY(from, to, duration, delay, timingFunction, mediaTimingFunction, removeOnCompletion, additive, completion),
            let .opacity(from, to, duration, delay, timingFunction, mediaTimingFunction, removeOnCompletion, additive, completion),
            let .originX(from, to, duration, delay, timingFunction, mediaTimingFunction, removeOnCompletion, additive, completion),
            let .originY(from, to, duration, delay, timingFunction, mediaTimingFunction, removeOnCompletion, additive, completion),
            let .rotation(from, to, duration, delay, timingFunction, mediaTimingFunction, removeOnCompletion, additive, completion):
            animate(
                from: NSNumber(value: from),
                to: NSNumber(value: to),
                keyPath: animation.keyPath,
                duration: duration,
                delay: delay,
                timingFunction: timingFunction,
                mediaTimingFunction: mediaTimingFunction,
                removeOnCompletion: removeOnCompletion,
                additive: additive,
                completion: completion
            )
        case let .position(from, to, duration, delay, timingFunction, mediaTimingFunction, removeOnCompletion, additive, force, completion),
            let .anchor(from, to, duration, delay, timingFunction, mediaTimingFunction, removeOnCompletion, additive, force, completion):
            if from == to && !force {
                if let completion {
                    completion(true)
                }
                return self
            }
            animate(
                from: NSValue(cgPoint: from),
                to: NSValue(cgPoint: to),
                keyPath: animation.keyPath,
                duration: duration,
                delay: delay,
                timingFunction: timingFunction,
                mediaTimingFunction: mediaTimingFunction,
                removeOnCompletion: removeOnCompletion,
                additive: additive,
                completion: completion
            )
        case let .positionX(from, to, duration, delay, timingFunction, mediaTimingFunction, removeOnCompletion, additive, force, completion),
            let .positionY(from, to, duration, delay, timingFunction, mediaTimingFunction, removeOnCompletion, additive, force, completion),
            let .height(from, to, duration, delay, timingFunction, mediaTimingFunction, removeOnCompletion, additive, force, completion),
            let .width(from, to, duration, delay, timingFunction, mediaTimingFunction, removeOnCompletion, additive, force, completion):
            if from == to && !force {
                if let completion {
                    completion(true)
                }
                return self
            }
            animate(
                from: NSNumber(value: from),
                to: NSNumber(value: to),
                keyPath: animation.keyPath,
                duration: duration,
                delay: delay,
                timingFunction: timingFunction,
                mediaTimingFunction: mediaTimingFunction,
                removeOnCompletion: removeOnCompletion,
                additive: additive,
                completion: completion
            )
        case let .bounds(from, to, duration, delay, timingFunction, mediaTimingFunction, removeOnCompletion, additive, force, completion):
            if from == to && !force {
                if let completion {
                    completion(true)
                }
                return self
            }
            animate(
                from: NSValue(cgRect: from),
                to: NSValue(cgRect: to),
                keyPath: #keyPath(CALayer.bounds),
                duration: duration,
                delay: delay,
                timingFunction: timingFunction,
                mediaTimingFunction: mediaTimingFunction,
                removeOnCompletion: removeOnCompletion,
                additive: additive,
                completion: completion
            )
        }
        return self
    }

    enum VAKeyFrameAnimation {
        case scale(
            values: [CGFloat],
            duration: Double,
            delay: Double = 0.0,
            timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
            mediaTimingFunction: CAMediaTimingFunction? = nil,
            removeOnCompletion: Bool = true,
            additive: Bool = false,
            completion: ((Bool) -> Void)? = nil
        )
        case positionX(
            values: [CGFloat],
            duration: Double,
            delay: Double = 0.0,
            timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
            mediaTimingFunction: CAMediaTimingFunction? = nil,
            removeOnCompletion: Bool = true,
            additive: Bool = false,
            completion: ((Bool) -> Void)? = nil
        )
        case positionY(
            values: [CGFloat],
            duration: Double,
            delay: Double = 0.0,
            timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
            mediaTimingFunction: CAMediaTimingFunction? = nil,
            removeOnCompletion: Bool = true,
            additive: Bool = false,
            completion: ((Bool) -> Void)? = nil
        )
        case opacity(
            values: [CGFloat],
            duration: Double,
            delay: Double = 0.0,
            timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
            mediaTimingFunction: CAMediaTimingFunction? = nil,
            removeOnCompletion: Bool = true,
            additive: Bool = false,
            completion: ((Bool) -> Void)? = nil
        )

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
    func add(animation: VAKeyFrameAnimation) -> Self {
        switch animation {
        case let .scale(values, duration, delay, timingFunction, mediaTimingFunction, removeOnCompletion, additive, completion),
            let .positionX(values, duration, delay, timingFunction, mediaTimingFunction, removeOnCompletion, additive, completion),
            let .positionY(values, duration, delay, timingFunction, mediaTimingFunction, removeOnCompletion, additive, completion),
            let .opacity(values, duration, delay, timingFunction, mediaTimingFunction, removeOnCompletion, additive, completion):
            animate(
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
        return self
    }

    private func animate(
        keyFrames: [Any],
        duration: Double,
        delay: Double,
        keyPath: String,
        timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        additive: Bool = false,
        completion: ((Bool) -> Void)? = nil
    ) {
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

        add(animation, forKey: keyPath)
    }

    private func animate(
        from: AnyObject?,
        to: AnyObject,
        keyPath: String,
        duration: Double,
        delay: Double,
        timingFunction: CAMediaTimingFunctionName,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        additive: Bool = false,
        completion: ((Bool) -> Void)? = nil
    ) {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
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
        animation.speed = speed
        animation.isAdditive = additive
        if let completion {
            animation.delegate = _AnimationDelegate(animation: animation, completion: completion)
        }
        add(animation, forKey: additive ? nil : keyPath)
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
