//
//  VAContainerButtonNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 13.04.2023.
//

import AsyncDisplayKit

/// `VAContainerButtonNode` is a subclass of `VAButtonNode` that includes a child node and handles button taps.
public final class VAContainerButtonNode<Node: ASDisplayNode>: VAButtonNode {
    /// The child node to be displayed within the container button.
    public let child: Node
    /// The insets to apply around the child node.
    public var insets: UIEdgeInsets {
        didSet { setNeedsLayout() }
    }
    /// A closure to be executed when the state of the button changes.
    public var onStateChange: ((_ node: VAContainerButtonNode<Node>, _ state: UIControl.State) -> Void)?

    public override var isHighlighted: Bool {
        didSet { updateButtonState() }
    }
    public override var isEnabled: Bool {
        didSet { updateButtonState() }
    }
    public override var isSelected: Bool {
        didSet { updateButtonState() }
    }

    /// Initializes the container button with a child node, insets, and a tap handler closure.
    ///
    /// - Parameters:
    ///   - child: The child node to be displayed within the container button.
    ///   - insets: The insets to apply around the child node.
    ///   - onTap: The closure to be executed when the container button is tapped.
    ///   - onStateChange: The closure to be executed when the state of the button changes.
    public init(
        child: Node,
        insets: UIEdgeInsets = .zero,
        onTap: (() -> Void)? = nil,
        onStateChange: ((_ node: VAContainerButtonNode<Node>, _ state: UIControl.State) -> Void)? = nil
    ) {
        self.child = child
        self.insets = insets

        super.init()

        if let onTap {
            self.onTap = onTap
        }
        if let onStateChange {
            self.onStateChange = onStateChange
        }
        automaticallyManagesSubnodes = true
    }

    public override func didLoad() {
        super.didLoad()

        updateButtonState()
    }

    private func updateButtonState() {
        guard let onStateChange else { return }

        if !isEnabled {
            onStateChange(self, .disabled)
        } else if isHighlighted && isSelected {
            onStateChange(self, [.highlighted, .selected])
        } else if isHighlighted {
            onStateChange(self, .highlighted)
        } else if isSelected {
            onStateChange(self, .selected)
        } else {
            onStateChange(self, .normal)
        }
    }

    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        child
            .padding(.insets(insets))
            .centered()
    }
}
