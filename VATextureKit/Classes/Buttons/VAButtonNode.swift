//
//  VAButtonNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 25.02.2023.
//

import AsyncDisplayKit

/// `VAButtonNode` is a subclass of `ASButtonNode` that provides additional functionality for handling button taps.
open class VAButtonNode: ASButtonNode, VACornerable {
    /// A closure that gets executed when the button is tapped. Use either `onTap` closure or `func onTap` function, but not both.
    public var onTap: (() -> Void)?
    /// The corner rounding configuration for the node.
    public var corner: VACornerRoundingParameters {
        didSet {
            guard oldValue != corner else { return }

            updateCornerParameters()
        }
    }

    public init(corner: VACornerRoundingParameters = .default) {
        self.corner = corner

        super.init()
    }

    @MainActor
    open override func didLoad() {
        super.didLoad()

        updateCornerParameters()
        bind()
    }

    @MainActor
    open override func layout() {
        super.layout()

        updateCornerProportionalIfNeeded()
    }

    /// Sets up a closure to handle the button tap event using weak references to avoid strong reference cycles. Use either `onTap` closure or `func onTap` function, but not both.
    ///
    /// - Parameters:
    ///   - object: The object to be weakly captured in the closure.
    ///   - block: The closure to be executed when the button is tapped.
    public func onTap<T: AnyObject>(weakify object: T, block: @escaping (T) -> Void) {
        onTap = { [weak object] in
            guard let object else { return }

            block(object)
        }
    }

    /// Sets up a closure to handle the button tap event using weak references to avoid strong reference cycles. Use either `onTap` closure or `func onTap` function, but not both.
    ///
    /// - Parameters:
    ///   - objects: A tuple of objects to be weakly captured in the closure.
    ///   - block: The closure to be executed when the button is tapped.
    public func onTap<T: AnyObject, U: AnyObject>(weakify objects: (T, U), block: @escaping (T, U) -> Void) {
        onTap = { [weak object0 = objects.0, weak object1 = objects.1] in
            guard let object0, let object1 else { return }

            block(object0, object1)
        }
    }
    
    @objc private func touchUpInside() {
        onTap?()
    }
    
    private func bind() {
        addTarget(
            self,
            action: #selector(touchUpInside),
            forControlEvents: .touchUpInside
        )
    }
}
