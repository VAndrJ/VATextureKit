//
//  VAShimmerTileNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 19.07.2023.
//

import AsyncDisplayKit

// TODO: - Documentation
open class VAShimmerTileNode: VADisplayNode {
    let backgroundColorGetter: (VATheme) -> UIColor

    public init(
        backgroundColor: @escaping (VATheme) -> UIColor = { $0.systemGray6 },
        corner: VACornerRoundingParameters = .init()
    ) {
        self.backgroundColorGetter = backgroundColor

        super.init(corner: corner)
    }

    open override func configureTheme(_ theme: VATheme) {
        backgroundColor = backgroundColorGetter(theme)
    }
}
