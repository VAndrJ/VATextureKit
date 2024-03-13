//
//  UIViewContainerScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 13.03.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct UIViewContainerNavigationIdentity: DefaultNavigationIdentity {}

final class UIViewContainerScreenNode: ScreenNode {
    private lazy var textHeightContainerNode = VASizedViewWrapperNode(
        childGetter: {
            UILabel().apply {
                $0.numberOfLines = 0
                $0.text = ".viewHeight sizing".dummyLong(repeating: 5)
                $0.backgroundColor = .systemGreen.withAlphaComponent(0.1)
            }
        },
        sizing: .viewHeight
    ).sized(width: 280)
    private lazy var textWidthContainerNode = VASizedViewWrapperNode(
        childGetter: {
            UILabel().apply {
                $0.numberOfLines = 0
                $0.text = ".viewWidth sizing".dummyLong(separator: "\n", repeating: 4)
                $0.backgroundColor = .systemOrange.withAlphaComponent(0.1)
            }
        },
        sizing: .viewWidth
    ).sized(height: 140)
    private lazy var textSizeContainerNode = VASizedViewWrapperNode(
        childGetter: {
            UILabel().apply {
                $0.numberOfLines = 0
                $0.text = ".viewSize sizing".dummyLong(repeating: 2).dummyLong(separator: "\n", repeating: 3)
                $0.backgroundColor = .systemPurple.withAlphaComponent(0.1)
            }
        },
        sizing: .viewSize
    )

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(spacing: 32) {
                textHeightContainerNode
                textWidthContainerNode
                textSizeContainerNode
            }
            .padding(.all(16))
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
}
