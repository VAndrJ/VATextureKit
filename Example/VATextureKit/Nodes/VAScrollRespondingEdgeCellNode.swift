//
//  VAScrollRespondingEdgeCellNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 30.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

// TODO: - Extend, add custom case
public enum VAEdgeCellChangeOnScroll {
    case none
    case opacity
    case scale
}

open class VAScrollRespondingEdgeCellNode: VACellNode, @unchecked Sendable {
    public let onScroll: VAEdgeCellChangeOnScroll
    public private(set) var isScrolling = false

    public init(onScroll: VAEdgeCellChangeOnScroll) {
        self.onScroll = onScroll

        super.init()
    }

    open override func didEnterDisplayState() {
        super.didEnterDisplayState()

        switch onScroll {
        case .none:
            break
        case .opacity:
            if isScrolling {
                layer.opacity = 0
            }
        case .scale:
            if isScrolling {
                layer.transform.m11 = 0
                layer.transform.m22 = 0
            }
        }
    }

    @MainActor
    open override func cellNodeVisibilityEvent(
        _ event: ASCellNodeVisibilityEvent,
        in scrollView: UIScrollView?,
        withCellFrame cellFrame: CGRect
    ) {
        if event == .didEndDragging {
            isScrolling = false
        }
        if event == .willBeginDragging {
            isScrolling = true
        }
        if let scrollView, event == .visibleRectChanged || event == .visible {
            let intersection = cellFrame.intersection(scrollView.bounds)
            guard !intersection.origin.y.isNaN || intersection.origin.y.isInfinite else { return }

            let multiplier = intersection.size.height / cellFrame.height
            switch onScroll {
            case .opacity:
                layer.opacity = Float(multiplier * multiplier)
            case .scale:
                let transform = multiplier * multiplier * multiplier
                layer.transform.m11 = transform
                layer.transform.m22 = transform
            case .none:
                break
            }
        }
    }
}
