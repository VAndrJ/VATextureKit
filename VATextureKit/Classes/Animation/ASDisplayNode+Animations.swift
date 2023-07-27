//
//  ASDisplayNode+Animation.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 02.04.2023.
//

import AsyncDisplayKit

extension ASDisplayNode {

    public func animateLayoutTransition(
        context: ASContextTransitioning,
        animation: VAAnimation = .default(),
        animate: (() -> Void)? = nil,
        completion: ((Bool) -> Void)? = nil
    ) {
        guard context.isAnimated() else {
            animate?()
            completion?(true)
            context.completeTransition(true)
            return
        }
        var insertions: [ASDisplayNode: NodeTransitionAnimation] = [:]
        context.insertedSubnodes().forEach {
            $0.frame = context.finalFrame(for: $0)
            var transition = $0.transition
            transition.beforeTransition(view: $0)
            transition.update(progress: .insertion(.start), view: $0)
            insertions[$0] = transition
        }
        var removals: [ASDisplayNode: NodeTransitionAnimation] = [:]
        context.removedSubnodes().forEach {
            $0.frame = context.initialFrame(for: $0)
            var transition = $0.transition
            transition.beforeTransition(view: $0)
            transition.update(progress: .removal(.start), view: $0)
            removals[$0] = transition
        }
        let subnodes = self.subnodes ?? []
        UIView.animate(with: animation) {
            insertions.forEach { $0.value.update(progress: .insertion(.end), view: $0.key) }
            removals.forEach { $0.value.update(progress: .removal(.end), view: $0.key) }
            subnodes.forEach {
                guard insertions[$0] == nil, removals[$0] == nil else { return }
                let finalFrame = context.finalFrame(for: $0)
                guard finalFrame.origin.x != .infinity, finalFrame.origin.y != .infinity else { return }
                $0.frame = context.finalFrame(for: $0)
            }
            animate?()
        } completion: {
            removals.forEach { $0.value.setInitialState(view: $0.key) }
            insertions.forEach { $0.value.setInitialState(view: $0.key) }
            completion?($0)
            context.completeTransition($0)
        }
    }
}

extension ASDisplayNode {
    public var transition: NodeTransitionAnimation {
        get { (objc_getAssociatedObject(self, &transitionKey) as? TransitionWrapper)?.transition ?? .identity }
        set { objc_setAssociatedObject(self, &transitionKey, TransitionWrapper(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

private final class TransitionWrapper {
    var transition: NodeTransitionAnimation

    init(_ transition: NodeTransitionAnimation) {
        self.transition = transition
    }
}

private var transitionKey = "transitionKey"

public typealias NodeTransitionAnimation = VATransition<ASDisplayNode>

extension ASDisplayNode: Transformable {
    public var affineTransform: CGAffineTransform {
        get { view.transform }
        set { view.transform = newValue }
    }
    public var isLtrDirection: Bool { view.isLtrDirection }
}

extension VATransition where Base == ASDisplayNode {
    public static var opacity: VATransition { .value(\.alpha, 0) }
    public static func cornerRadius(_ radius: CGFloat) -> VATransition { .value(\.cornerRadius, radius) }
}

extension ASDisplayNode {

    /// Animate node with given transition.
    ///
    /// - Parameters:
    ///   - transition: Transition.
    ///   - direction: Transition direction.
    ///   - animation: Animation parameters.
    ///   - restoreState: Restore node state on animation completion
    ///   - completion: Block to be executed when animation finishes.
    public func animate(
        transition: NodeTransitionAnimation,
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
    public func set(hidden: Bool, transition: NodeTransitionAnimation, animation: VAAnimation = .default(), completion: (() -> Void)? = nil) {
        set(
            hidden: hidden,
            insideAnimation: false,
            set: { $0.isHidden = $1 },
            transition: transition,
            animation: animation,
            completion: completion
        )
    }

    /// Animated remove from supernode with given transition.
    ///
    /// - Parameters:
    ///   - transition: Transition.
    ///   - animation: Animation parameters.
    ///   - completion: Block to be executed when transition finishes.
    public func removeFromSupernode(transition: NodeTransitionAnimation, animation: VAAnimation = .default(), completion: (() -> Void)? = nil) {
        addOrRemove(to: supernode, add: false, transition: transition, animation: animation, completion: completion)
    }

    /// Animated add a subview with given transition.
    ///
    /// - Parameters:
    ///   - subview: Subnode to be added.
    ///   - transition: Transition.
    ///   - animation: Animation parameters.
    ///   - completion: Block to be executed when transition finishes.
    public func add(subnode: ASDisplayNode, transition: NodeTransitionAnimation, animation: VAAnimation = .default(), completion: (() -> Void)? = nil) {
        subnode.addOrRemove(to: self, add: true, transition: transition, animation: animation, completion: completion)
    }

    public func addOrRemove(
        to supernode: ASDisplayNode?,
        add: Bool,
        transition: NodeTransitionAnimation,
        animation: VAAnimation = .default(),
        completion: (() -> Void)? = nil
    ) {
        set(
            hidden: !add,
            insideAnimation: false,
            set: {
                if $1 {
                    $0.removeFromSupernode()
                } else {
                    supernode?.addSubnode(self)
                }
            },
            transition: transition,
            animation: animation,
            completion: completion
        )
    }

    private func set(
        hidden: Bool,
        insideAnimation: Bool,
        set: @escaping (ASDisplayNode, Bool) -> Void,
        transition: NodeTransitionAnimation,
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
                self.supernode?.layoutIfNeeded()
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

public enum RelationValue<Value> {
    case absolute(Value)
    case relative(Double)

    public var absolute: Value? {
        if case let .absolute(value) = self {
            return value
        }
        return nil
    }

    public var relative: Double? {
        if case let .relative(value) = self {
            return value
        }
        return nil
    }

    public var type: RelationType {
        switch self {
        case .absolute: return .absolute
        case .relative: return .relative
        }
    }
}

extension RelationValue where Value == CGFloat {

    public func value(for full: Value) -> Value {
        switch self {
        case let .absolute(value):
            return value
        case let .relative(koeficient):
            var result = full
            result *= koeficient
            return result
        }
    }
}

public enum RelationType: String, Hashable {
    case absolute
    case relative
}

extension RelationValue: Equatable where Value: Equatable {}
extension RelationValue: Hashable where Value: Hashable {}

public func / <F: BinaryFloatingPoint>(_ lhs: RelationValue<F>, _ rhs: F) -> RelationValue<F> {
    switch lhs {
    case let .absolute(value): return .absolute(value / rhs)
    case let .relative(value): return .relative(value / Double(rhs))
    }
}

public func * <F: BinaryFloatingPoint>(_ lhs: RelationValue<F>, _ rhs: F) -> RelationValue<F> {
    switch lhs {
    case let .absolute(value): return .absolute(value * rhs)
    case let .relative(value): return .relative(value * Double(rhs))
    }
}

public func * <F: BinaryFloatingPoint>(_ lhs: F, _ rhs: RelationValue<F>) -> RelationValue<F> {
    rhs * lhs
}

public protocol Transformable {
    var frame: CGRect { get nonmutating set }
    var bounds: CGRect { get nonmutating set }
    var anchorPoint: CGPoint { get nonmutating set }
    var affineTransform: CGAffineTransform { get nonmutating set }
    var isLtrDirection: Bool { get }

    func convert(_ frame: CGRect, to: Self?) -> CGRect
}

extension Transformable {

    subscript<A, B>(keyPath1: ReferenceWritableKeyPath<Self, A>, keyPath2: ReferenceWritableKeyPath<Self, B>) -> (A, B) {
        get { (self[keyPath: keyPath1], self[keyPath: keyPath2]) }
        nonmutating set {
            self[keyPath: keyPath1] = newValue.0
            self[keyPath: keyPath2] = newValue.1
        }
    }
}

extension UIView: Transformable {
    public var affineTransform: CGAffineTransform {
        get { transform }
        set { transform = newValue }
    }
    public var anchorPoint: CGPoint {
        get { layer.anchorPoint }
        set { layer.anchorPoint = newValue }
    }
    public var isLtrDirection: Bool {
        UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .leftToRight
    }
}

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
}

import CoreGraphics

public enum TransitionDirection: String, Hashable, CaseIterable {
    case insertion
    case removal

    public func at(_ value: CGFloat) -> Progress {
        switch self {
        case .insertion: return .insertion(value)
        case .removal: return .removal(value)
        }
    }

    public func at(_ value: Progress.Edge) -> Progress {
        switch self {
        case .insertion: return .insertion(value)
        case .removal: return .removal(value)
        }
    }
}

public protocol TransitionModifier {
    associatedtype Root
    associatedtype Value

    func matches(other: Self) -> Bool
    func set(value: Value, to root: Root)
    func value(for root: Root) -> Value
}

public struct KeyPathModifier<Root, Value>: TransitionModifier {
    public var keyPath: ReferenceWritableKeyPath<Root, Value>

    public func matches(other: KeyPathModifier) -> Bool {
        other.keyPath == keyPath
    }

    public func set(value: Value, to root: Root) {
        root[keyPath: keyPath] = value
    }

    public func value(for root: Root) -> Value {
        root[keyPath: keyPath]
    }
}

extension TransitionModifier {
    public var any: AnyTransitionModifier<Root> { AnyTransitionModifier(self) }

    public func map<T>(_ transform: @escaping (T) -> Root) -> MapTransitionModifier<Self, T> {
        MapTransitionModifier(base: self, transform: transform)
    }
}

public struct AnyTransitionModifier<Root>: TransitionModifier {
    private let isMatch: (AnyTransitionModifier) -> Bool
    private let setter: (Any, Root) -> Void
    private let getter: (Root) -> Any

    public init<T: TransitionModifier>(_ modifier: T) where T.Root == Root {
        isMatch = {
            ($0 as? T).map { modifier.matches(other: $0) } ?? false
        }
        setter = {
            guard let value = $0 as? T.Value else { return }
            modifier.set(value: value, to: $1)
        }
        getter = {
            modifier.value(for: $0)
        }
    }

    public func matches(other: AnyTransitionModifier) -> Bool {
        isMatch(other)
    }

    public func set(value: Any, to root: Root) {
        setter(value, root)
    }

    public func value(for root: Root) -> Any {
        getter(root)
    }
}

public struct MapTransitionModifier<Base: TransitionModifier, Root>: TransitionModifier {
    public typealias Value = Base.Value

    private let base: Base
    private let map: (Root) -> Base.Root

    public init(base: Base, transform: @escaping (Root) -> Base.Root) {
        self.base = base
        self.map = transform
    }

    public func matches(other: MapTransitionModifier<Base, Root>) -> Bool {
        base.matches(other: other.base)
    }

    public func set(value: Base.Value, to root: Root) {
        base.set(value: value, to: map(root))
    }

    public func value(for root: Root) -> Base.Value {
        base.value(for: map(root))
    }
}

public extension ASDisplayNode {

    func setNeedsLayoutAnimated(shouldMeasureAsync: Bool = false, completion: (() -> Void)? = nil) {
        transitionLayout(withAnimation: true, shouldMeasureAsync: shouldMeasureAsync, measurementCompletion: completion)
        var supernode = supernode
        while supernode != nil {
            if supernode is ASScrollNode {
                supernode?.setNeedsLayoutAnimated()
                return
            }
            supernode = supernode?.supernode
        }
    }

    @discardableResult
    func animate(
        _ animation: CALayer.VAAnimation,
        duration: Double,
        delay: Double = 0.0,
        timeOffset: Double = 0.0,
        repeatCount: Float = 0.0,
        timingFunction: CAMediaTimingFunctionName = .easeInEaseOut,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        applyingResult: Bool = false,
        autoreverses: Bool = false,
        additive: Bool = false,
        continueFromCurrent: Bool = false,
        force: Bool = false,
        spring: CALayer.VASpring? = nil,
        completion: ((Bool) -> Void)? = nil
    ) -> Self {
        ensureOnMain { [self] in
            layer.add(
                animation: animation,
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
            if applyingResult {
                layer.setValue(animation.values.to, forKeyPath: animation.keyPath)
            }
        }
        return self
    }

    @discardableResult
    func animate(
        _ animation: CALayer.VAKeyFrameAnimation,
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
        ensureOnMain { [self] in
            layer.add(
                animation: animation,
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
        }
        return self
    }

    func disableAllLayerAnimations() {
        ensureOnMain { [self] in
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            disableAllAnimations(layer: layer)
            CATransaction.commit()
        }
    }

    private func disableAllAnimations(layer: CALayer) {
        ensureOnMain { [self] in
            layer.removeAllAnimations()
            layer.sublayers?.forEach(disableAllAnimations(layer:))
        }
    }

    func getHasAnimations(_ block: @escaping (Bool) -> Void) {
        ensureOnMain { [self] in
            block(layer.hasAnimations)
        }
    }

    func pauseAnimations() {
        ensureOnMain { [self] in
            layer.pauseAnimations()
        }
    }

    func resumeAnimations() {
        ensureOnMain { [self] in
            layer.resumeAnimations()
        }
    }
}
