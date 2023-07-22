//
//  CountingTextNodeController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 22.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class CountingTextNodeController: VASafeAreaDisplayNode {
    private lazy var countingTextNode = VACountingTextNode(string: "", color: { $0.label }).apply {
        $0.updateCount(to: 0)
    }
    private lazy var randomButtonNode = VAButtonNode()

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
        randomButtonNode.configure(title: "Random", theme: theme)
    }

    private func bind() {
        randomButtonNode.onTap = countingTextNode ?> { $0.updateCount(to: Int.random(in: 0...1000)) }
    }
}
