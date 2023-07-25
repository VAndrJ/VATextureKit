//
//  TransitionAnimationControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 02.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class TransitionAnimationControllerNode: VASafeAreaDisplayNode {
    let leftTextNode = VATextNode(text: "left", fontStyle: .body, alignment: .center)
        .withAnimatedTransition(id: "Test")
        .flex(shrink: 0.1, basisPercent: 60)
    let rightTextNode = VATextNode(text: "right", fontStyle: .body, alignment: .center)
        .withAnimatedTransition(id: "Test1")
        .flex(basisPercent: 40)
    let exchangeButtonNode = HapticButtonNode()
    let toggleNode = VATextNode(
        text: .loremText,
        fontStyle: .body,
        alignment: .center
    ).apply {
        $0.transition = .slide
    }
    let toggleButtonNode = HapticButtonNode()
    let expandButtonNode = HapticButtonNode()
    let expandNode = VADisplayNode()
        .sized(width: 100, height: 50)
    var isNodesExchanged = false {
        didSet { setNeedsLayoutAnimated() }
    }
    var isNodeToggled = false {
        didSet { setNeedsLayoutAnimated() }
    }
    var isNodeExpanded = false {
        didSet { setNeedsLayoutAnimated() }
    }

    override func didLoad() {
        super.didLoad()

        bind()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(spacing: 16, cross: .stretch) {
                Row(spacing: 16) {
                    if isNodesExchanged {
                        rightTextNode
                        leftTextNode
                    } else {
                        leftTextNode
                        rightTextNode
                    }
                }
                exchangeButtonNode

                if isNodeToggled {
                    toggleNode
                }
                toggleButtonNode

                Row {
                    expandNode
                        .flex(grow: isNodeExpanded ? 1 : 0)
                }
                expandButtonNode
            }
            .padding(.all(16))
        }
    }

    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        animateLayoutTransition(context: context)
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground

        leftTextNode.backgroundColor = theme.systemOrange
        rightTextNode.backgroundColor = theme.systemTeal
        exchangeButtonNode.tintColor = theme.systemBlue
        exchangeButtonNode.configure(title: "Exchange", theme: theme)

        toggleButtonNode.configure(title: "Toggle", theme: theme)

        expandNode.backgroundColor = theme.systemPurple
        expandButtonNode.configure(title: "Expand", theme: theme)
    }

    private func bind() {
        exchangeButtonNode.onTap = self ?> { $0.isNodesExchanged.toggle() }
        toggleButtonNode.onTap = self ?> { $0.isNodeToggled.toggle() }
        expandButtonNode.onTap = self ?> { $0.isNodeExpanded.toggle() }
    }
}
