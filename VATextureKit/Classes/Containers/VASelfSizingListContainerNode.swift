//
//  VASelfSizingListContainerNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 23.11.2023.
//

import AsyncDisplayKit

open class VASelfSizingListContainerNode<ListNode: ASCollectionNode>: VADisplayNode {
    public enum Direction {
        case vertical
        case horizontal
    }

    public let child: ListNode
    public let direction: Direction

    private var observation: NSKeyValueObservation?

    public init(child: ListNode, direction: Direction, corner: VACornerRoundingParameters = .default) {
        self.child = child
        self.direction = direction

        super.init(corner: corner)
    }

    @MainActor
    open override func didLoad() {
        super.didLoad()

        configure()
        bind()
    }

    open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        child
            .wrapped()
    }

    private func bind() {
        observation = child.observe(
            \.view.contentSize,
             options: [.initial, .new],
             changeHandler: { [weak self] _, value in
                 guard let self, let size = value.newValue, self.view.frame.size != size else { return }
                 
                 switch self.direction {
                 case .vertical:
                     self.style.height = .points(size.height)
                 case .horizontal:
                     self.style.width = .points(size.width)
                 }
                 self.setNeedsLayout()
             }
        )
    }

    @MainActor
    private func configure() {
        child.view.contentInsetAdjustmentBehavior = .never
        child.view.isScrollEnabled = false
    }
}
