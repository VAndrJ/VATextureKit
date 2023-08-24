//
//  VAShimmerTileNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 19.07.2023.
//

import AsyncDisplayKit

// TODO: - Documentation, tests
open class VAShimmerTileNode: VADisplayNode, VACornerable {
    public let corner: VACornerRoundingParameters

    let backgroundColorGetter: (VATheme) -> UIColor

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

        updateCornerProportionalIfNeeded()
    }

    open override func configureTheme(_ theme: VATheme) {
        backgroundColor = backgroundColorGetter(theme)
    }
}
