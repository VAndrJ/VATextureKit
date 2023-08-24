//
//  VANodeWrapperView.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 01.04.2023.
//

import AsyncDisplayKit

/// A UIView subclass for wrapping `Texture` nodes within a `UIKit`-based view hierarchy.
/// You can use this view to seamlessly integrate `ASDisplayNodes` with `UIKit` components.
open class VANodeWrapperView<Node: ASDisplayNode>: UIView {
    /// The content node embedded within the wrapper view.
    public var contentNode: Node { contentNodeView.node }

    /// The internal view responsible for displaying the content node.
    private let contentNodeView: _ContentNodeView<Node>

    /// Creates an instance.
    ///
    /// - Parameters:
    ///   - contentNode: The ASDisplayNode to be wrapped and displayed within the wrapper view.
    ///   - shouldExpandToMaximumWidth: A boolean value that determines whether the content node should expand to the maximum available width within its bounding rectangle.
    public init(contentNode: Node, shouldExpandToMaximumWidth: Bool = false) {
        self.contentNodeView = _ContentNodeView(
            node: contentNode,
            shouldExpandToMaximumWidth: shouldExpandToMaximumWidth
        )

        super.init(frame: .zero)

        addSubview(contentNodeView)
        contentNodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentNodeView.leftAnchor.constraint(equalTo: leftAnchor),
            contentNodeView.rightAnchor.constraint(equalTo: rightAnchor),
            contentNodeView.topAnchor.constraint(equalTo: topAnchor),
            contentNodeView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func invalidateIntrinsicContentSize() {
        contentNodeView.invalidateIntrinsicContentSize()

        super.invalidateIntrinsicContentSize()
    }
}

// swiftlint:disable implicitly_unwrapped_optional
private final class _ContentNodeView<Node: ASDisplayNode>: UILabel { // To use `textRect` method
    @available(*, unavailable)
    override var text: String? {
        didSet {}
    }
    @available(*, unavailable)
    override var font: UIFont! {
        didSet {}
    }
    @available(*, unavailable)
    override var textColor: UIColor! {
        didSet {}
    }
    @available(*, unavailable)
    override var shadowColor: UIColor? {
        didSet {}
    }
    @available(*, unavailable)
    override var shadowOffset: CGSize {
        didSet {}
    }
    @available(*, unavailable)
    override var textAlignment: NSTextAlignment {
        didSet {}
    }
    @available(*, unavailable)
    override var lineBreakMode: NSLineBreakMode {
        didSet {}
    }
    @available(*, unavailable)
    override var attributedText: NSAttributedString? {
        didSet {}
    }
    @available(*, unavailable)
    override var highlightedTextColor: UIColor? {
        didSet {}
    }
    @available(*, unavailable)
    override var isHighlighted: Bool {
        didSet {}
    }
    @available(*, unavailable)
    override var isEnabled: Bool {
        didSet {}
    }
    @available(*, unavailable)
    override var numberOfLines: Int {
        didSet {}
    }
    @available(*, unavailable)
    override var adjustsFontSizeToFitWidth: Bool {
        didSet {}
    }
    @available(*, unavailable)
    override var baselineAdjustment: UIBaselineAdjustment {
        didSet {}
    }
    @available(*, unavailable)
    override var minimumScaleFactor: CGFloat {
        didSet {}
    }
    @available(*, unavailable)
    override var allowsDefaultTighteningForTruncation: Bool {
        didSet {}
    }
    @available(*, unavailable)
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect)
    }
    @available(*, unavailable)
    override var preferredMaxLayoutWidth: CGFloat {
        didSet {}
    }

    public let shouldExpandToMaximumWidth: Bool

    let node: Node

    private let wrapperNode: _WrapperNode
    private let delegateProxy = _InterfaceStateDelegateProxy()

    init(node: Node, shouldExpandToMaximumWidth: Bool) {
        self.node = node
        self.wrapperNode = _WrapperNode(wrappedNode: node)
        self.shouldExpandToMaximumWidth = shouldExpandToMaximumWidth

        super.init(frame: .zero)

        super.numberOfLines = 0 // To call `textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int)`
        isUserInteractionEnabled = true
        addSubnode(wrapperNode)
        wrapperNode.add(delegateProxy)
        delegateProxy.didLayoutBlock = { [weak self] in
            self?.invalidateIntrinsicContentSize()
        }
        ASTraitCollectionPropagateDown(
            wrapperNode,
            ASPrimitiveTraitCollectionFromUITraitCollection(traitCollection)
        )
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        ASTraitCollectionPropagateDown(
            wrapperNode,
            ASPrimitiveTraitCollectionFromUITraitCollection(traitCollection)
        )
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let validateWidth: (_ value: CGFloat, _ fallback: CGFloat) -> CGFloat = { value, fallback in
            guard ASPointsValidForSize(value) else { // To guard crash
                return fallback
            }

            return value
        }

        var range = ASSizeRange.unconstrained
        range.max.width = validateWidth(bounds.width, 10000)
        if shouldExpandToMaximumWidth {
            range.min.width = validateWidth(bounds.width, 0)
        }
        let calculatedlayout = wrapperNode.calculateLayoutThatFits(range)
        
        return CGRect(origin: .zero, size: calculatedlayout.size)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        wrapperNode.frame = bounds
    }

    deinit {
        node.remove(delegateProxy)
    }
}

private final class _WrapperNode: ASDisplayNode {
    private let wrappedNode: ASDisplayNode

    init(wrappedNode: ASDisplayNode) {
        self.wrappedNode = wrappedNode

        super.init()

        addSubnode(wrappedNode)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        ASWrapperLayoutSpec(layoutElement: wrappedNode)
    }
}

private final class _InterfaceStateDelegateProxy: NSObject, ASInterfaceStateDelegate {
    var didLayoutBlock: (() -> Void)?

    func didEnterDisplayState() {}

    @objc dynamic func nodeDidLayout() {
        didLayoutBlock?()
    }

    @objc dynamic func interfaceStateDidChange(_ newState: ASInterfaceState, from oldState: ASInterfaceState) {}

    @objc dynamic func didEnterVisibleState() {}

    @objc dynamic func didExitVisibleState() {}

    @objc dynamic func didExitDisplayState() {}

    @objc dynamic func didEnterPreloadState() {}

    @objc dynamic func didExitPreloadState() {}

    @objc dynamic func nodeDidLoad() {}

    @objc dynamic func hierarchyDisplayDidFinish() {}
}
