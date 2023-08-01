//
//  CountingTextNodeController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 22.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class CountingTextNodeController: VASafeAreaDisplayNode {
    private lazy var countingTextNode = VACountingTextNode(string: "", color: { $0.label }, descriptor: .monospacedDigits).apply {
        $0.updateCount(to: 0)
    }
    private lazy var randomButtonNode = HapticButtonNode(title: "Random")

    override func didLoad() {
        super.didLoad()

        bind()
    }

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

    private func bind() {
        randomButtonNode.onTap = self ?> { $0.countingTextNode.updateCount(to: Int.random(in: 0...1000)) }
    }
}
