//
//  ViewHostingScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 13.03.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import SwiftUI
import VATextureKit

struct ViewHostingNavigationIdentity: DefaultNavigationIdentity {}

final class ViewHostingScreenNode: ScreenNode, @unchecked Sendable {
    private lazy var textHeightContainerNode = VAViewHostingNode(
        body: {
            Text(".viewHeight sizing".dummyLong(repeating: 5))
                .background(Color.green.opacity(0.1))
        },
        sizing: .viewHeight
    ).sized(width: 280)
    private lazy var textWidthContainerNode = VAViewHostingNode(
        body: {
            VStack {
                Text(".viewWidth sizing")
                Spacer()
                Text(".viewWidth sizing")
            }
            .background(Color.orange.opacity(0.1))
        },
        sizing: .viewWidth
    ).sized(height: 140)
    private lazy var textSizeContainerNode = VAViewHostingNode(
        body: {
            Text(".viewSize sizing".dummyLong(repeating: 2).dummyLong(separator: "\n", repeating: 3))
                .background(Color.purple.opacity(0.1))
        },
        sizing: .viewSize
    )

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(spacing: 16) {
                textWidthContainerNode
                textSizeContainerNode
                textHeightContainerNode
            }
            .padding(.all(16))
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
}
