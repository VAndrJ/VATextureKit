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
    private lazy var inheritedSizeContainerNode = VAViewWrapperNode(
        childGetter: {
            UIView(frame: .init(width: 48, height: 24)).apply {
                $0.backgroundColor = .systemGreen
            }
        },
        sizing: .inheritedSize
    )
    private lazy var inheritedWidthContainerNode = VAViewWrapperNode(
        childGetter: {
            UIView(frame: .init(width: 48, height: 24)).apply {
                $0.backgroundColor = .systemOrange
            }
        },
        sizing: .inheritedWidth
    ).sized(height: 48)
    private lazy var inheritedHeightContainerNode = VAViewWrapperNode(
        childGetter: {
            UIView(frame: .init(width: 48, height: 24)).apply {
                $0.backgroundColor = .systemYellow
            }
        },
        sizing: .inheritedHeight
    ).sized(width: 96)
    private lazy var noSizingContainerNode = VAViewWrapperNode(
        childGetter: {
            UIView(frame: .init(width: 48, height: 24)).apply {
                $0.backgroundColor = .systemPink
            }
        },
        sizing: .none
    ).sized(CGSize(same: 36))
    private lazy var fixedSizeContainerNode = VAViewWrapperNode(
        childGetter: {
            UIView(frame: .init(width: 48, height: 24)).apply {
                $0.backgroundColor = .systemPurple
            }
        },
        sizing: .fixedSize(CGSize(same: 36))
    )
    private lazy var fixedWidthContainerNode = VAViewWrapperNode(
        childGetter: {
            UIView(frame: .init(width: 48, height: 24)).apply {
                $0.backgroundColor = .systemTeal
            }
        },
        sizing: .fixedWidth(96)
    ).sized(height: 48)
    private lazy var fixedHeightContainerNode = VAViewWrapperNode(
        childGetter: {
            UIView(frame: .init(width: 48, height: 24)).apply {
                $0.backgroundColor = .systemBrown
            }
        },
        sizing: .fixedHeight(48)
    ).sized(width: 24)

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(spacing: 4, cross: .stretch) {
                inheritedSizeContainerNode
                inheritedWidthContainerNode
                inheritedHeightContainerNode
                noSizingContainerNode
                fixedSizeContainerNode
                fixedWidthContainerNode
                fixedHeightContainerNode
            }
            .padding(.all(16))
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
}
