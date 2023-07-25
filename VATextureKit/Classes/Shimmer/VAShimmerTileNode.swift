//
//  VAShimmerTileNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 19.07.2023.
//

import AsyncDisplayKit

open class VAShimmerTileNode: VADisplayNode {
    public struct DTO {
        let backgroundColor: (VATheme) -> UIColor
        // Rounded on nil
        let cornerRadius: CGFloat?

        public init(
            backgroundColor: @escaping (VATheme) -> UIColor = { $0.systemGray6 },
            cornerRadius: CGFloat? = 0.0
        ) {
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
        }
    }

    let data: DTO

    public init(data: DTO) {
        self.data = data

        super.init()

        if let cornerRadius = data.cornerRadius {
            self.cornerRadius = cornerRadius
        }
    }

    public override func layout() {
        super.layout()

        if data.cornerRadius == nil {
            self.cornerRadius = min(bounds.width, bounds.height) / 2
        }
    }

    open override func configureTheme(_ theme: VATheme) {
        backgroundColor = data.backgroundColor(theme)
    }
}
