//
//  VAShimmerTileNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 19.07.2023.
//

import AsyncDisplayKit

/// `VAShimmerTileNode` is a subclass of `VADisplayNode` designed for creating shimmering tile-like UI components with customizable background colors.
open class VAShimmerTileNode: VADisplayNode {
    /// A closure that determines the background color based on the current theme.
    let backgroundColorGetter: (VATheme) -> UIColor

    /// Initializes a `VAShimmerTileNode` instance with customizable background color and corner rounding.
    ///
    /// - Parameters:
    ///   - backgroundColor: A closure that returns the desired background color based on the current theme.
    ///   - corner: The corner rounding parameters to apply to the tile.
    public init(
        backgroundColor: @escaping (VATheme) -> UIColor = { $0.systemGray6 },
        corner: VACornerRoundingParameters = .default
    ) {
        self.backgroundColorGetter = backgroundColor

        super.init(corner: corner)
    }

    /// Configure the tile's background color based on the current theme.
    open override func configureTheme(_ theme: VATheme) {
        backgroundColor = backgroundColorGetter(theme)
    }
}
