//
//  FilterScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 28.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct FilterNavigationIdentity: DefaultNavigationIdentity {}

final class FilterScreenNode: ScreenNode {
    private lazy var imageNode = VAImageNode(
        image: filter.outputImage(image: R.image.colibri()),
        size: CGSize(same: 300),
        contentMode: .scaleAspectFit
    )

    private let filter = MetalDropPixelsFilter()

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            imageNode
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
}
