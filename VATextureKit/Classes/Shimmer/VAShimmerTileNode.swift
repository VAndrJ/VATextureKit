//
//  VAShimmerTileNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 19.07.2023.
//

import AsyncDisplayKit

// TODO: - Documentation, tests
open class VAShimmerTileNode: VADisplayNode {
    let backgroundColorGetter: (VATheme) -> UIColor
    let corner: VACornerRoundingParameters

    public init(
        backgroundColor: @escaping (VATheme) -> UIColor = { $0.systemGray6 },
        corner: VACornerRoundingParameters = .init()
    ) {
        self.backgroundColorGetter = backgroundColor
        self.corner = corner

        super.init()
    }

    open override func didLoad() {
        super.didLoad()

        updateCornerParameters()
    }

    public override func layout() {
        super.layout()

        if case let .proportional(percent) = corner.radius {
            cornerRadius = min(bounds.width, bounds.height) * percent / 200
        }
    }

    open override func configureTheme(_ theme: VATheme) {
        backgroundColor = backgroundColorGetter(theme)
    }

    private func updateCornerParameters() {
        cornerCurve = corner.curve
        cornerRoundingType = corner.roundingType
        if case let .fixed(value) = corner.radius {
            cornerRadius = value
        } else {
            setNeedsLayout()
        }
    }
}
