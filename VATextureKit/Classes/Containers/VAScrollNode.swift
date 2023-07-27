//
//  VAScrollNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 31.03.2023.
//

import AsyncDisplayKit

open class VAScrollNode: ASScrollNode {
    public struct DTO {
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

    let data: DTO

    public init(data: DTO) {
        self.data = data

        super.init()

        automaticallyManagesSubnodes = true
        automaticallyManagesContentSize = true
        shouldAnimateSizeChanges = data.shouldAnimateSizeChanges
        scrollableDirections = data.scrollableDirections
    }

    open override func didLoad() {
        super.didLoad()

        configure()
    }

    open override func animateLayoutTransition(_ context: ASContextTransitioning) {
        animateLayoutTransition(context: context)
    }

    private func configure() {
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceVertical = data.alwaysBounceVertical
        view.alwaysBounceHorizontal = data.alwaysBounceHorizontal
        view.contentInsetAdjustmentBehavior = .never
        if let bounces = data.bounces {
            view.bounces = bounces
        }
        if let isPagingEnabled = data.isPagingEnabled {
            view.isPagingEnabled = isPagingEnabled
        }
        view.contentInset = data.contentInset
    }
}
