//
//  VAContainerButtonNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 13.04.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

/// `VAContainerButtonNode` is a subclass of `VAButtonNode` that includes a child node and handles button state changes.
open class VAContainerButtonNode<Node: ASDisplayNode>: VAButtonNode {
    /// The child node to be displayed within the container button.
    public let child: Node
    /// The insets to apply around the child node.
    public var insets: UIEdgeInsets {
        didSet { setNeedsLayout() }
    }
    /// A closure to be executed when the state of the button changes. Also called in `didLoad`.
    public var onStateChange: ((_ node: VAContainerButtonNode<Node>, _ state: UIControl.State) -> Void)?

    open override var isHighlighted: Bool {
        didSet { updateButtonState() }
    }
    open override var isEnabled: Bool {
        didSet { updateButtonState() }
    }
    open override var isSelected: Bool {
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

    open override func viewDidLoad() {
        super.viewDidLoad()

        updateButtonState()
    }

    open func updateButtonState() {
        guard let onStateChange else { return }

        switch (isEnabled, isHighlighted, isSelected) {
        case (true, false, false):
            onStateChange(self, .normal)
        case (true, true, false):
            onStateChange(self, .highlighted)
        case (true, false, true):
            onStateChange(self, .selected)
        case (true, true, true):
            onStateChange(self, [.highlighted, .selected])
        case (false, _, _):
            onStateChange(self, .disabled)
        }
    }

    open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        child
            .padding(.insets(insets))
            .centered()
    }
}
