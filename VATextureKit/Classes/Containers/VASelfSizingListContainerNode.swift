//
//  VASelfSizingListContainerNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 23.11.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

open class VASelfSizingListContainerNode<ListNode: ASCollectionNode>: VADisplayNode, @unchecked Sendable {
    public enum Direction {
        case vertical
        case horizontal
    }

    public let child: ListNode
    public let direction: Direction

    private var observation: NSKeyValueObservation?

    public init(
        child: ListNode,
        direction: Direction,
        corner: VACornerRoundingParameters = .default
    ) {
        self.child = child
        self.direction = direction

        super.init(corner: corner)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        bind()
    }

    open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        child
            .wrapped()
    }

    @MainActor
    private func bind() {
        observation = child.observe(
            \.view.contentSize,
             options: [.initial, .new],
             changeHandler: { [weak self] _, value in
                 guard let self, let size = value.newValue else { return }
                 ensureOnMain {
                     MainActor.assumeIsolated {
                         guard self.view.frame.size != size else { return }
                         
                         switch self.direction {
                         case .vertical:
                             self.style.height = .points(size.height)
                         case .horizontal:
                             self.style.width = .points(size.width)
                         }
                         self.setNeedsLayout()
                     }
                 }
             }
        )
    }

    @MainActor
    private func configure() {
        child.view.contentInsetAdjustmentBehavior = .never
        child.view.isScrollEnabled = false
    }
}
