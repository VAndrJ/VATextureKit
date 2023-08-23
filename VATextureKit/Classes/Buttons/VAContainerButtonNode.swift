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
    /// A closure to be executed when the highlighting state of the button changes.
    public var onHighlight: ((_ child: Node, _ isHighlighted: Bool) -> Void)?

    public override var isHighlighted: Bool {
        didSet { onHighlight?(child, isHighlighted) }
    }

    /// Initializes the container button with a child node, insets, and a tap handler closure.
    ///
    /// - Parameters:
    ///   - child: The child node to be displayed within the container button.
    ///   - insets: The insets to apply around the child node.
    ///   - onTap: The closure to be executed when the container button is tapped.
    ///   - onHighlight: The closure to be executed when the highlighting state of the button changes.
    public init(
        child: Node,
        insets: UIEdgeInsets = .zero,
        onTap: (() -> Void)? = nil,
        onHighlight: ((_ child: Node, _ isHighlighted: Bool) -> Void)? = nil
    ) {
        self.child = child
        self.insets = insets

        super.init()

        if let onTap {
            self.onTap = onTap
        }
        if let onHighlight {
            self.onHighlight = onHighlight
        }
        automaticallyManagesSubnodes = true
    }

    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        child
            .padding(.insets(insets))
            .centered()
    }
}
