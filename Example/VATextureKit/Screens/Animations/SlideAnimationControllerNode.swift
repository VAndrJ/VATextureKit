//
//  SlideAnimationControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 02.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class SlideAnimationControllerNode: VASafeAreaDisplayNode {
    let leftNode = VATextNode(text: "left", fontStyle: .body, alignment: .center)
        .flex(shrink: 0.1, basisPercent: 60)
    let rightNode = VATextNode(text: "right", fontStyle: .body, alignment: .center)
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
    let expandNode = ASDisplayNode()
        .sized(width: 100, height: 50)
    var isNodesExchanged = false {
        didSet { transitionLayout(withAnimation: true, shouldMeasureAsync: false) }
    }
    var isNodeToggled = false {
        didSet { transitionLayout(withAnimation: true, shouldMeasureAsync: false) }
    }
    var isNodeExpanded = false {
        didSet { transitionLayout(withAnimation: true, shouldMeasureAsync: false) }
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
                        rightNode
                        leftNode
                    } else {
                        leftNode
                        rightNode
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
        leftNode.backgroundColor = theme.systemOrange
        rightNode.backgroundColor = theme.systemTeal
        exchangeButtonNode.tintColor = theme.systemBlue
        expandNode.backgroundColor = theme.systemPurple
        exchangeButtonNode.configure(title: "Exchange", theme: theme)
        toggleButtonNode.configure(title: "Toggle", theme: theme)
        expandButtonNode.configure(title: "Expand", theme: theme)
    }

    private func bind() {
        exchangeButtonNode.onTap(weakify: self) {
            $0.isNodesExchanged.toggle()
        }
        toggleButtonNode.onTap(weakify: self) {
            $0.isNodeToggled.toggle()
        }
        expandButtonNode.onTap(weakify: self) {
            $0.isNodeExpanded.toggle()
        }
    }
}
