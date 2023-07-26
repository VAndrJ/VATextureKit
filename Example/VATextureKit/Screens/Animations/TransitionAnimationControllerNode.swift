//
//  TransitionAnimationControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 02.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class TransitionAnimationControllerNode: VASafeAreaDisplayNode {
    private lazy var leftTextNode = VATextNode(text: "left", fontStyle: .body, alignment: .center)
        .withAnimatedTransition(id: "Test")
        .flex(shrink: 0.1, basisPercent: 60)
    private lazy var rightTextNode = VATextNode(text: "right", fontStyle: .body, alignment: .center)
        .withAnimatedTransition(id: "Test1")
        .flex(basisPercent: 40)
    private lazy var exchangeButtonNode = HapticButtonNode()
    private lazy var toggleNode = VATextNode(
        text: .loremText,
        fontStyle: .body,
        alignment: .center
    ).apply {
        $0.transition = .slide
    }
    private lazy var toggleButtonNode = HapticButtonNode()
    private lazy var expandButtonNode = HapticButtonNode()
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
    private lazy var presentButtonNode = HapticButtonNode()
        .withAnimatedTransition(id: "button")
    private lazy var dismissButtonNode = HapticButtonNode()
    private let isPresented: Bool

    init(isPresented: Bool) {
        self.isPresented = isPresented

        super.init()
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

                presentButtonNode
                    .padding(.top(32))
                if isPresented {
                    dismissButtonNode
                }
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

        presentButtonNode.configure(title: "Present", theme: theme)
        if isPresented {
            dismissButtonNode.configure(title: "Dismiss", theme: theme)
        }
    }

    private func bind() {
        exchangeButtonNode.onTap = self ?> { $0.isNodesExchanged.toggle() }
        toggleButtonNode.onTap = self ?> { $0.isNodeToggled.toggle() }
        expandButtonNode.onTap = self ?> { $0.isNodeExpanded.toggle() }
        presentButtonNode.onTap = self ?> {
            $0.closestViewController?.present(
                VAViewController(node: TransitionAnimationControllerNode(isPresented: true)).withAnimatedTransitionEnabled(),
                animated: true
            )
        }
        if isPresented {
            dismissButtonNode.onTap = self ?> { $0.closestViewController?.dismiss(animated: true) }
        }
    }
}
