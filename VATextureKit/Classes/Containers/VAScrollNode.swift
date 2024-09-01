//
//  VAScrollNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 31.03.2023.
//

public import AsyncDisplayKit

open class VAScrollNode: VASimpleScrollNode {
    public struct Context {
        let scrollableDirections: ASScrollDirection
        let alwaysBounceVertical: Bool
        let alwaysBounceHorizontal: Bool
        let bounces: Bool?
        let isPagingEnabled: Bool?
        let contentInset: UIEdgeInsets
        let contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior
        let shouldAnimateSizeChanges: Bool

        public init(
            scrollableDirections: ASScrollDirection = .vertical,
            alwaysBounceVertical: Bool = true,
            alwaysBounceHorizontal: Bool = false,
            bounces: Bool? = nil,
            isPagingEnabled: Bool? = nil,
            contentInset: UIEdgeInsets = .zero,
            contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior = .never,
            shouldAnimateSizeChanges: Bool = true
        ) {
            self.scrollableDirections = scrollableDirections
            self.alwaysBounceVertical = alwaysBounceVertical
            self.alwaysBounceHorizontal = alwaysBounceHorizontal
            self.bounces = bounces
            self.isPagingEnabled = isPagingEnabled
            self.contentInset = contentInset
            self.contentInsetAdjustmentBehavior = contentInsetAdjustmentBehavior
            self.shouldAnimateSizeChanges = shouldAnimateSizeChanges
        }
    }

    let context: Context

    public init(context: Context) {
        self.context = context

        super.init()

        automaticallyManagesSubnodes = true
        automaticallyManagesContentSize = true
        shouldAnimateSizeChanges = context.shouldAnimateSizeChanges
        scrollableDirections = context.scrollableDirections
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    open override func viewDidAnimateLayoutTransition(_ context: any ASContextTransitioning) {
        animateLayoutTransition(context: context)
    }

    @MainActor
    private func configure() {
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceVertical = context.alwaysBounceVertical
        view.alwaysBounceHorizontal = context.alwaysBounceHorizontal
        view.contentInsetAdjustmentBehavior = .never
        if let bounces = context.bounces {
            view.bounces = bounces
        }
        if let isPagingEnabled = context.isPagingEnabled {
            view.isPagingEnabled = isPagingEnabled
        }
        view.contentInset = context.contentInset
    }
}
