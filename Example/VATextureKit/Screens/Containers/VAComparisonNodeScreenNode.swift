//
//  VAComparisonNodeScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 06.04.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct VAComparisonNodeIdentity: DefaultNavigationIdentity {}

class VAComparisonNodeScreenNode: ScreenNode, @unchecked Sendable {
    private lazy var comparisonNode = VAComparisonNode(
        firstNode: ImageCellNode(viewModel: .init(image: testImages.randomElement())),
        secondNode: ImageNumberCellNode(viewModel: .init(image: testImages.randomElement(), number: 2))
    ).sized(height: 200)

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(cross: .stretch) {
                comparisonNode
            }
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
}
