//
//  SlideAnimationControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 02.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class SlideAnimationControllerNode: VASafeAreaDisplayNode {
    let leftNode = VATextNode(text: "left", textStyle: .body, alignment: .center)
        .flex(shrink: 0.1, basisPercent: 60)
    let rightNode = VATextNode(text: "right", textStyle: .body, alignment: .center)
        .flex(basisPercent: 40)
    let exchangeButtonNode = HapticButtonNode()
        .apply {
            $0.setTitle("Exchange", with: nil, with: nil, for: .normal)
        }
    let toggleNode = VATextNode(
        text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        textStyle: .body,
        alignment: .center
    ).apply {
        $0.transition = .slide
    }
    let toggleButtonNode = HapticButtonNode()
        .apply {
            $0.setTitle("Toggle", with: nil, with: nil, for: .normal)
        }
    let expandButtonNode = HapticButtonNode()
        .apply {
            $0.setTitle("Expand", with: nil, with: nil, for: .normal)
        }
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
    }

    private func bind() {
        exchangeButtonNode.onTap = { [weak self] in
            self?.isNodesExchanged.toggle()
        }
        toggleButtonNode.onTap = { [weak self] in
            self?.isNodeToggled.toggle()
        }
        expandButtonNode.onTap = { [weak self] in
            self?.isNodeExpanded.toggle()
        }
    }
}
