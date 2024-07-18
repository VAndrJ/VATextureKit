//
//  TransitionAnimationScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 02.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct TransitionAnimationNavigationIdentity: DefaultNavigationIdentity {}

final class TransitionAnimationScreenNode: ScreenNode {
    private lazy var leftTextNode = VATextNode(text: "left", fontStyle: .body, alignment: .center)
        .withAnimatedTransition(id: "Test")
        .flex(shrink: 0.1, basisPercent: 60)
    private lazy var rightTextNode = VATextNode(text: "right", fontStyle: .body, alignment: .center)
        .withAnimatedTransition(id: "Test1")
        .flex(basisPercent: 40)
    private lazy var exchangeButtonNode = HapticButtonNode(title: "Exchange")
    private lazy var toggleNode = VATextNode(
        text: .loremText,
        fontStyle: .body,
        alignment: .center
    ).apply {
        $0.transition = .slide
    }
    private lazy var toggleButtonNode = HapticButtonNode(title: "Toggle")
    private lazy var expandButtonNode = HapticButtonNode(title: "Expand")
    private lazy var expandNode = VADisplayNode()
        .sized(width: 100, height: 50)
    private var isNodesExchanged = false {
        didSet { setNeedsLayoutAnimated() }
    }
    private var isNodeToggled = false {
        didSet { setNeedsLayoutAnimated() }
    }
    private var isNodeExpanded = false {
        didSet { setNeedsLayoutAnimated() }
    }
    private lazy var presentButtonNode = HapticButtonNode(title: "Present")
        .withAnimatedTransition(id: "button")
    private lazy var dismissButtonNode = HapticButtonNode(title: "Dismiss")
    private let isPresented: Bool

    init(isPresented: Bool) {
        self.isPresented = isPresented

        super.init()
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

                presentButtonNode
                    .padding(.top(32))
                if isPresented {
                    dismissButtonNode
                }
            }
            .padding(.all(16))
        }
    }

    @MainActor
    override func animateLayoutTransition(_ context: any ASContextTransitioning) {
        animateLayoutTransition(context: context)
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground

        leftTextNode.backgroundColor = theme.systemOrange
        rightTextNode.backgroundColor = theme.systemTeal
        exchangeButtonNode.tintColor = theme.systemBlue

        expandNode.backgroundColor = theme.systemPurple
    }

    override func bind() {
        exchangeButtonNode.onTap = self ?> { $0.isNodesExchanged.toggle() }
        toggleButtonNode.onTap = self ?> { $0.isNodeToggled.toggle() }
        expandButtonNode.onTap = self ?> { $0.isNodeExpanded.toggle() }
        presentButtonNode.onTap = self ?> {
            $0.closestViewController?.present(
                VAViewController(node: TransitionAnimationScreenNode(isPresented: true))
                    .withAnimatedTransitionEnabled(),
                animated: true
            )
        }
        if isPresented {
            dismissButtonNode.onTap = self ?> { $0.closestViewController?.dismiss(animated: true) }
        }
    }
}
