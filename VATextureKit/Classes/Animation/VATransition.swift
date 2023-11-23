//
//  VATransition.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 02.04.2023.
//

import Foundation

public struct VATransition<Base>: ExpressibleByArrayLiteral {
    public var isIdentity: Bool { transitions.isEmpty }

    private var transitions: [Transition]
    private var modifiers: [AnyTransitionModifier<Base>]
    private var initialStates: [Any]

    public init<T: TransitionModifier>(
        _ modifier: T,
        initialState: T.Value? = nil,
        transition: @escaping (Progress, Base, T.Value) -> Void
    ) where T.Root == Base {
        transitions = [
            Transition { progress, view, value in
                let value = initialState ?? (value as? T.Value) ?? modifier.value(for: view)
                transition(progress, view, value)
            }
        ]
        modifiers = [
            AnyTransitionModifier(modifier),
        ]
        initialStates = initialState.map { [$0] } ?? []
    }

    public init<T>(
        _ keyPath: ReferenceWritableKeyPath<Base, T>,
        initialState: T? = nil,
        transition: @escaping (Progress, Base, T) -> Void
    ) {
        transitions = [
            Transition { progress, view, value in
                let value = initialState ?? (value as? T) ?? view[keyPath: keyPath]
                transition(progress, view, value)
            }
        ]
        modifiers = [
            AnyTransitionModifier(KeyPathModifier(keyPath: keyPath)),
        ]
        initialStates = initialState.map { [$0] } ?? []
    }

    public init(arrayLiteral elements: VATransition...) {
        self = .combined(elements)
    }

    init(
        transitions: [Transition],
        modifiers: [AnyTransitionModifier<Base>],
        initialStates: [Any]
    ) {
        self.transitions = transitions
        self.modifiers = modifiers
        self.initialStates = initialStates
    }

    public mutating func beforeTransition(view: Base) {
        initialStates = modifiers.map { $0.value(for: view) }
    }

    public mutating func beforeTransitionIfNeeded(view: Base) {
        guard initialStates.isEmpty else { return }

        beforeTransition(view: view)
    }

    public mutating func reset() {
        initialStates = []
    }

    public func setInitialState(view: Base) {
        zip(initialStates, modifiers).forEach {
            $0.1.set(value: $0.0, to: view)
        }
    }

    public func update(progress: Progress, view: Base) {
        var initialStates = initialStates
        if initialStates.isEmpty {
            initialStates = modifiers.map { $0.value(for: view) }
        }
        zip(transitions, initialStates).forEach {
            $0.0.block(progress, view, $0.1)
        }
    }
}

extension VATransition {
    struct Transition {
        var block: (_ progress: Progress, _ view: Base, _ initialValue: Any?) -> Void
    }
}

extension VATransition {
    public var inverted: VATransition {
        VATransition(
            transitions: transitions.map { transition in
                Transition {
                    transition.block($0.inverted, $1, $2)
                }
            },
            modifiers: modifiers,
            initialStates: initialStates
        )
    }
    public var reversed: VATransition {
        VATransition(
            transitions: transitions.map { transition in
                Transition {
                    transition.block($0.reversed, $1, $2)
                }
            },
            modifiers: modifiers,
            initialStates: initialStates
        )
    }

    private var flat: [VATransition] {
        if initialStates.isEmpty {
            return zip(transitions, modifiers).map {
                VATransition(transitions: [$0.0], modifiers: [$0.1], initialStates: [])
            }
        } else {
            return zip(zip(transitions, modifiers), initialStates).map {
                VATransition(transitions: [$0.0.0], modifiers: [$0.0.1], initialStates: [$0.1])
            }
        }
    }

    /// Combines all transition, returning a new transition that is the result of all transitions being applied.
    ///
    /// - Parameter transitions: Transitions to be combined.
    /// - Returns: New transition.
    public static func combined(_ transitions: [VATransition]) -> VATransition {
        guard !transitions.isEmpty else {
            return .identity
        }

        var result = VATransition.identity

        for transition in transitions.flatMap({ $0.flat }) {
            if let i = result.modifiers.firstIndex(where: { transition.modifiers[0].matches(other: $0) }) {
                let current = result.transitions[i]
                result.transitions[i] = Transition {
                    current.block($0, $1, $2)
                    transition.transitions[0].block($0, $1, $2)
                }
            } else {
                result.transitions += transition.transitions
                result.modifiers += transition.modifiers
                result.initialStates += result.initialStates
            }
        }
        if result.initialStates.count != result.transitions.count {
            result.initialStates = []
        }
        return result
    }

    public func combined(with transition: VATransition) -> VATransition {
        .combined(self, transition)
    }

    public func filter(_ type: @escaping (Progress) -> Bool) -> VATransition {
        VATransition(
            transitions: transitions.map { transition in
                Transition {
                    guard type($0) else { return }
                    transition.block($0, $1, $2)
                }
            },
            modifiers: modifiers,
            initialStates: initialStates
        )
    }

    public func map<T>(_ transform: @escaping (T) -> Base) -> VATransition<T> {
        VATransition<T>(
            transitions: transitions.map { transition in
                VATransition<T>.Transition {
                    transition.block($0, transform($1), $2)
                }
            },
            modifiers: modifiers.map {
                $0.map(transform).any
            },
            initialStates: initialStates
        )
    }
}

extension VATransition {
    public static var identity: VATransition {
        VATransition(
            transitions: [],
            modifiers: [],
            initialStates: []
        )
    }

    /// Combines all transition, returning a new transition that is the result of all transitions being applied.
    ///
    /// - Parameter transitions: Transitions to be combined.
    /// - Returns: New transition.
    public static func combined(_ transitions: VATransition...) -> VATransition {
        .combined(transitions)
    }

    /// Provides a composite transition that uses a different transition for insertion versus removal.
    public static func asymmetric(insertion: VATransition, removal: VATransition) -> VATransition {
        insertion.filter(\.isInsertion)
            .combined(with: removal.filter { !$0.isInsertion })
    }

    public static func value(_ keyPath: ReferenceWritableKeyPath<Base, CGFloat>, _ transformed: CGFloat, default defaultValue: CGFloat? = nil) -> VATransition {
        VATransition(keyPath) { progress, view, value in
            view[keyPath: keyPath] = progress.value(identity: defaultValue ?? value, transformed: transformed)
        }
    }

    public static func constant<T>(_ keyPath: ReferenceWritableKeyPath<Base, T>, _ value: T) -> VATransition {
        VATransition(keyPath) { _, view, _ in
            view[keyPath: keyPath] = value
        }
    }
}

extension VATransition where Base: Transformable {
    public static var scale: VATransition { .scale(0.0001) }
    public static var slide: VATransition { .slide(insertion: .leading, removal: .trailing) }

    public static func scale(_ scale: CGPoint) -> VATransition {
        VATransition(\.affineTransform) { progress, view, transform in
            view.affineTransform = transform.scaledBy(
                x: progress.value(identity: 1, transformed: scale.x),
                y: progress.value(identity: 1, transformed: scale.y)
            )
        }
    }

    public static func scale(_ scale: CGFloat) -> VATransition {
        .scale(CGPoint(x: scale, y: scale))
    }

    public static func scale(_ scale: CGPoint, anchor: CGPoint) -> VATransition {
        VATransition(\.[\.affineTransform, \.anchorPoint]) { progress, view, transform in
            let anchor = view.isLtrDirection ? anchor : CGPoint(x: 1 - anchor.x, y: anchor.y)
            let scaleX = scale.x != 0 ? scale.x : 0.0001
            let scaleY = scale.y != 0 ? scale.y : 0.0001
            let xPadding = 1 / scaleX * (anchor.x - transform.1.x) * view.bounds.width
            let yPadding = 1 / scaleY * (anchor.y - transform.1.y) * view.bounds.height

            view.anchorPoint = CGPoint(
                x: progress.value(identity: transform.1.x, transformed: anchor.x),
                y: progress.value(identity: transform.1.y, transformed: anchor.y)
            )
            view.affineTransform = transform.0
                .scaledBy(
                    x: progress.value(identity: 1, transformed: scaleX),
                    y: progress.value(identity: 1, transformed: scaleY)
                )
                .translatedBy(
                    x: progress.value(identity: 0, transformed: xPadding),
                    y: progress.value(identity: 0, transformed: yPadding)
                )
        }
    }

    public static func scale(_ scale: CGFloat = 0.0001, anchor: CGPoint) -> VATransition {
        .scale(CGPoint(x: scale, y: scale), anchor: anchor)
    }

    public static func anchor(point: CGPoint) -> VATransition {
        VATransition(\.anchorPoint) { progress, view, anchor in
            let point = view.isLtrDirection ? point : CGPoint(x: 1 - point.x, y: point.y)
            let anchorPoint = CGPoint(
                x: progress.value(identity: anchor.x, transformed: point.x),
                y: progress.value(identity: anchor.y, transformed: point.y)
            )
            view.anchorPoint = anchorPoint
        }
    }

    public static func offset(_ point: CGPoint) -> VATransition {
        VATransition(\.affineTransform) { progress, view, affineTransform in
            view.affineTransform = affineTransform.translatedBy(
                x: progress.value(identity: 0, transformed: point.x),
                y: progress.value(identity: 0, transformed: point.y)
            )
        }
    }

    public static func offset(x: CGFloat = 0, y: CGFloat = 0) -> VATransition {
        .offset(CGPoint(x: x, y: y))
    }

    public static func move(edge: VAEdge, offset: RelationValue<CGFloat> = .relative(1)) -> VATransition {
        VATransition(\.affineTransform) { progress, view, affineTransform in
            switch (edge, view.isLtrDirection) {
            case (.leading, true), (.trailing, false):
                view.affineTransform = affineTransform.translatedBy(
                    x: progress.value(identity: 0, transformed: -offset.value(for: view.frame.width)),
                    y: 0
                )
            case (.leading, false), (.trailing, true):
                view.affineTransform = affineTransform.translatedBy(
                    x: progress.value(identity: 0, transformed: offset.value(for: view.frame.width)),
                    y: 0
                )
            case (.top, _):
                view.affineTransform = affineTransform.translatedBy(
                    x: 0,
                    y: progress.value(identity: 0, transformed: -offset.value(for: view.frame.height))
                )
            case (.bottom, _):
                view.affineTransform = affineTransform.translatedBy(
                    x: 0,
                    y: progress.value(identity: 0, transformed: offset.value(for: view.frame.height))
                )
            }
        }
    }

    public static func slide(insertion: VAEdge, removal: VAEdge) -> VATransition {
        .asymmetric(insertion: .move(edge: insertion), removal: .move(edge: removal))
    }
}

/// An enumeration that represents the different edges in a layout.
public enum VAEdge {
    case top
    case leading
    case bottom
    case trailing
}

public enum Progress: Hashable, Codable {
    public enum Edge {
        case start
        case end

        public var progress: CGFloat {
            switch self {
            case .start: return 0
            case .end: return 1
            }
        }
    }

    public static func insertion(_ edge: Edge) -> Progress {
        .insertion(edge.progress)
    }

    public static func removal(_ edge: Edge) -> Progress {
        .removal(edge.progress)
    }

    case insertion(CGFloat)
    case removal(CGFloat)

    public var value: CGFloat {
        get {
            switch self {
            case let .insertion(value): return value
            case let .removal(value): return value
            }
        }
        set {
            switch self {
            case .insertion: self = .insertion(newValue)
            case .removal: self = .removal(newValue)
            }
        }
    }
    public var progress: CGFloat {
        get {
            switch self {
            case let .insertion(value): return value
            case let .removal(value): return 1 - value
            }
        }
        set {
            switch self {
            case .insertion: self = .insertion(newValue)
            case .removal: self = .removal(1 - newValue)
            }
        }
    }
    public var inverted: Progress {
        switch self {
        case let .insertion(value): return .removal(1 - value)
        case let .removal(value): return .insertion(1 - value)
        }
    }
    public var reversed: Progress {
        switch self {
        case let .insertion(value): return .insertion(1 - value)
        case let .removal(value): return .removal(1 - value)
        }
    }
    public var direction: TransitionDirection {
        get {
            switch self {
            case .insertion: return .insertion
            case .removal: return .removal
            }
        }
        set { self = newValue.at(value) }
    }
    public var isRemoval: Bool {
        get {
            if case .removal = self {
                return true
            }
            
            return false
        }
        set { direction = newValue ? .removal : .insertion }
    }
    public var isInsertion: Bool {
        get {
            if case .insertion = self {
                return true
            }

            return false
        }
        set { direction = newValue ? .insertion : .removal }
    }

    public func value(identity: CGFloat, transformed: CGFloat) -> CGFloat {
        var result = identity - transformed
        result *= progress
        return transformed + result
    }
}
