//
//  CountingTextNodeController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 22.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct CountingTextNodeNavigationIdentity: DefaultNavigationIdentity {}

final class CountingTextNodeController: ScreenNode {
    private lazy var countingTextNode = VACountingTextNode(
        string: "",
        color: { $0.label },
        descriptor: .monospacedDigits
    ).apply {
        $0.updateCount(to: 0)
    }
    private lazy var randomButtonNode = HapticButtonNode(title: "Random")

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(spacing: 16, cross: .center) {
                countingTextNode
                randomButtonNode
            }
            .padding(.all(16))
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }

    override func bind() {
        randomButtonNode.onTap = self ?> { $0.countingTextNode.updateCount(to: Int.random(in: 0...1000)) }
    }
}
