//
//  VAAnimation.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 02.04.2023.
//

import UIKit

public struct VAAnimation: ExpressibleByArrayLiteral {
    public static var defaultDuration: Double = 0.25
    public static var defaultDamping: CGFloat = 0.825

    public var duration: Double
    public var delay: Double
    public var spring: Spring?
    public var options: UIView.AnimationOptions

    public init(
        duration: Double = VAAnimation.defaultDuration,
        delay: Double = 0,
        spring: Spring? = nil,
        options: UIView.AnimationOptions = []
    ) {
        self.duration = duration
        self.delay = delay
        self.spring = spring
        self.options = options
    }

    public init(arrayLiteral elements: UIView.AnimationOptions...) {
        self.init(options: UIView.AnimationOptions(elements))
    }

    public static func `default`(
        _ duration: Double = VAAnimation.defaultDuration,
        delay: Double = 0,
        options: UIView.AnimationOptions = [.curveEaseInOut]
    ) -> VAAnimation {
        VAAnimation(
            duration: duration,
            delay: delay,
            options: options
        )
    }

    public static func `repeat`(
        _ duration: Double = VAAnimation.defaultDuration,
        delay: Double = 0,
        options: UIView.AnimationOptions = [.curveEaseInOut, .autoreverse]
    ) -> VAAnimation {
        VAAnimation(
            duration: duration,
            delay: delay,
            options: options.intersection(.repeat)
        )
    }

    public static func spring(
        _ duration: Double = VAAnimation.defaultDuration,
        delay: Double = 0,
        damping: CGFloat = VAAnimation.defaultDamping,
        initialVelocity: CGFloat = 0,
        options: UIView.AnimationOptions = []
    ) -> VAAnimation {
        VAAnimation(
            duration: duration,
            delay: delay,
            spring: Spring(damping: damping, initialVelocity: initialVelocity),
            options: options
        )
    }

    public func delay(_ delay: Double) -> VAAnimation {
        var result = self
        result.delay = delay

        return result
    }

    public func options(_ options: UIView.AnimationOptions...) -> VAAnimation {
        var result = self
        options.forEach { result.options.insert($0) }

        return result
    }
}

extension VAAnimation {
    public struct Spring {
        /// The damping ratio for the spring animation as it approaches its quiescent state.
        /// To smoothly decelerate the animation without oscillation, use a value of 1.
        /// Employ a damping ratio closer to zero to increase oscillation.
        public var damping: CGFloat
        /// The initial spring velocity. For smooth start to the animation, match this value to the view’s velocity as it was prior to attachment
        /// A value of 1 corresponds to the total animation distance traversed in one second.
        /// For example, if the total animation distance is 200 points and you want the start of the animation to match a view velocity of 100 pt/s, use a value of 0.5.
        public var initialVelocity: CGFloat

        public init(damping: CGFloat = VAAnimation.defaultDamping, initialVelocity: CGFloat = 0) {
            self.damping = damping
            self.initialVelocity = initialVelocity
        }
    }
}

extension UIView {

    /// Animate changes to one or more views using the specified duration, delay, options, and completion handle.
    ///
    /// - Parameters:
    ///   - animation: Animation options.
    ///   - animations: A block object containing the changes to commit to the views. This is where you programmatically change any animatable properties of the views in your view hierarchy. This block takes no parameters and has no return value.
    ///   - completion: A block object to be executed when the animation sequence ends. This block has no return value and takes a single Boolean argument that indicates whether or not the animations actually finished before the completion handler was called. If the duration of the animation is 0, this block is performed at the beginning of the next run loop cycle.
    public static func animate(
        with animation: VAAnimation,
        _ animations: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil
    ) {
        if let spring = animation.spring {
            animate(
                withDuration: animation.duration,
                delay: animation.delay,
                usingSpringWithDamping: spring.damping,
                initialSpringVelocity: spring.initialVelocity,
                options: animation.options,
                animations: animations,
                completion: completion
            )
        } else {
            animate(
                withDuration: animation.duration,
                delay: animation.delay,
                options: animation.options,
                animations: animations,
                completion: completion
            )
        }
    }
}

public typealias UIViewTransition = VATransition<UIView>

extension UIView {

    /// Animate view with given transition.
    ///
    /// - Parameters:
    ///   - transition: Transition.
    ///   - direction: Transition direction.
    ///   - animation: Animation parameters.
    ///   - restoreState: Restore view state on animation completion
    ///   - completion: Block to be executed when animation finishes.
    public func animate(
        transition: UIViewTransition,
        direction: TransitionDirection = .removal,
        animation: VAAnimation = .default(),
        restoreState: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        var transition = transition
        UIView.performWithoutAnimation {
            transition.beforeTransition(view: self)
            transition.update(progress: direction.at(.start), view: self)
        }
        UIView.animate(with: animation) { [self] in
            transition.update(progress: direction.at(.end), view: self)
        } completion: { [self] _ in
            completion?()
            if restoreState {
                transition.setInitialState(view: self)
            }
        }
    }

    /// Animated change `isHidden` property with given transition.
    ///
    /// - Parameters:
    ///   - hidden: `isHidden` value to be set.
    ///   - transition: Transition.
    ///   - animation: Animation parameters.
    ///   - completion: Block to be executed when transition finishes.
    public func set(hidden: Bool, transition: UIViewTransition, animation: VAAnimation = .default(), completion: (() -> Void)? = nil) {
        set(
            hidden: hidden,
            insideAnimation: (superview as? UIStackView) != nil,
            set: { $0.isHidden = $1 },
            transition: transition,
            animation: animation,
            completion: completion
        )
    }

    /// Animated remove from superview with given transition.
    ///
    /// - Parameters:
    ///   - transition: Transition.
    ///   - animation: Animation parameters.
    ///   - completion: Block to be executed when transition finishes.
    public func removeFromSuperview(transition: UIViewTransition, animation: VAAnimation = .default(), completion: (() -> Void)? = nil) {
        addOrRemove(
            to: superview,
            add: false,
            transition: transition,
            animation: animation,
            completion: completion
        )
    }

    /// Animated add a subview with given transition.
    ///
    /// - Parameters:
    ///   - subview: Subview to be added.
    ///   - transition: Transition.
    ///   - animation: Animation parameters.
    ///   - completion: Block to be executed when transition finishes.
    public func add(subview: UIView, transition: UIViewTransition, animation: VAAnimation = .default(), completion: (() -> Void)? = nil) {
        subview.addOrRemove(
            to: self,
            add: true,
            transition: transition,
            animation: animation,
            completion: completion
        )
    }

    public func addOrRemove(
        to superview: UIView?,
        add: Bool,
        transition: UIViewTransition,
        animation: VAAnimation = .default(),
        completion: (() -> Void)? = nil
    ) {
        set(
            hidden: !add,
            insideAnimation: false,
            set: { if $1 { $0.removeFromSuperview() } else { superview?.addSubview(self) } },
            transition: transition,
            animation: animation,
            completion: completion
        )
    }

    private func set(
        hidden: Bool,
        insideAnimation: Bool,
        set: @escaping (UIView, Bool) -> Void,
        transition: UIViewTransition,
        animation: VAAnimation = .default(),
        completion: (() -> Void)? = nil
    ) {
        guard !transition.isIdentity else {
            set(self, hidden)
            completion?()
            return
        }

        let direction: TransitionDirection = hidden ? .removal : .insertion
        var transition = transition
        UIView.performWithoutAnimation {
            transition.beforeTransition(view: self)
            transition.update(progress: direction.at(.start), view: self)
            if !hidden, !insideAnimation {
                set(self, false)
            }
        }
        UIView.animate(with: animation) {
            if insideAnimation {
                set(self, hidden)
                self.superview?.layoutIfNeeded()
            }
            transition.update(progress: direction.at(.end), view: self)
        } completion: { _ in
            if hidden, !insideAnimation {
                set(self, true)
            }
            transition.setInitialState(view: self)
            completion?()
        }
    }
}

extension VATransition where Base: Transformable & AnyObject {

    public static func transform(to targetView: Base) -> VATransition {
        VATransition(TransformToModifier(targetView)) { progress, view, initial in
            let (sourceScale, sourceOffset) = transform(
                progress: progress,
                initial: initial
            )
            view.affineTransform = initial.sourceTransform
                .translatedBy(x: sourceOffset.x, y: sourceOffset.y)
                .scaledBy(x: sourceScale.width, y: sourceScale.height)
        }
    }

    private static func transform(progress: Progress, initial: Matching) -> (scale: CGSize, offset: CGPoint) {
        let scale = CGSize(
            width: progress.value(
                identity: 1,
                transformed: initial.targetRect.width / initial.sourceRect.width.notZero
            ),
            height: progress.value(
                identity: 1,
                transformed: initial.targetRect.height / initial.sourceRect.height.notZero
            )
        )
        let offset = CGPoint(
            x: progress.value(
                identity: 0,
                transformed: initial.targetRect.midX - initial.sourceRect.midX
            ),
            y: progress.value(
                identity: 0,
                transformed: initial.targetRect.midY - initial.sourceRect.midY
            )
        )
        
        return (scale, offset)
    }
}

private struct TransformToModifier<Root: Transformable & AnyObject>: TransitionModifier {
    public typealias Value = Matching

    weak var target: Root?

    init(_ target: Root?) {
        self.target = target
    }

    func matches(other: TransformToModifier<Root>) -> Bool {
        other.target === target
    }

    func set(value: Matching, to root: Root) {
        root.affineTransform = value.sourceTransform
    }

    func value(for root: Root) -> Matching {
        Matching(
            sourceTransform: root.affineTransform,
            targetTransform: target?.affineTransform ?? root.affineTransform,
            sourceRect: root.convert(root.bounds, to: nil),
            targetRect: target?.convert(target?.bounds ?? .zero, to: nil) ?? root.convert(root.bounds, to: nil)
        )
    }
}

private struct Matching {
    var sourceTransform: CGAffineTransform
    var targetTransform: CGAffineTransform
    var sourceRect: CGRect
    var targetRect: CGRect
}

extension CGFloat {
    var notZero: CGFloat { self == 0 ? 0.0001 : self }
}
