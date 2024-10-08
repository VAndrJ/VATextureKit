//
//  LayerAnimationScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 21.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct LayerAnimationNavigationIdentity: DefaultNavigationIdentity {}

final class LayerAnimationScreenNode: ScrollScreenNode, @unchecked Sendable {
    private lazy var boundsAnimationExampleNode = _BoundsAnimationExampleNode()
    private lazy var opacityAnimationExampleNode = _OpacityAnimationExampleNode()
    private lazy var scaleAnimationExampleNode = _ScaleAnimationExampleNode()
    private lazy var rotationAnimationExampleNode = _RotationAnimationExampleNode()
    private lazy var cornerRadiusAnimationExampleNode = _CornerRadiusAnimationExampleNode()
    private lazy var colorAnimationExampleNode = _ColorAnimationExampleNode()

    override func scrollLayoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 16, cross: .stretch) {
            boundsAnimationExampleNode
            opacityAnimationExampleNode
            colorAnimationExampleNode
            scaleAnimationExampleNode
            rotationAnimationExampleNode
            cornerRadiusAnimationExampleNode
        }
        .padding(.all(16))
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
}

private class _CornerRadiusAnimationExampleNode: DisplayNode, @unchecked Sendable {
    private lazy var exampleNode = VADisplayNode()
        .sized(width: 100, height: 40)
    private lazy var buttonNode = HapticButtonNode(title: "Toggle corner radius")
    private var isToggled = false {
        didSet {
            exampleNode.animate(
                .cornerRadius(
                    from: oldValue ? 20 : 0,
                    to: !oldValue ? 20 : 0
                ),
                duration: 2,
                applyingResult: true,
                continueFromCurrent: true
            )
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(cross: .stretch) {
            exampleNode
            buttonNode
        }
    }

    override func configureTheme(_ theme: VATheme) {
        exampleNode.backgroundColor = theme.systemGray
    }

    override func bind() {
        buttonNode.onTap = self ?> { $0.isToggled.toggle() }
    }
}

private class _RotationAnimationExampleNode: DisplayNode, @unchecked Sendable {
    private lazy var exampleNode = VAImageNode(
        image: .init(resource: .chevronRight),
        size: .init(same: 50),
        contentMode: .center,
        tintColor: { $0.darkText }
    )
    private lazy var buttonNode = HapticButtonNode(title: "Toggle rotation")
    private var isToggled = false {
        didSet {
            exampleNode.animate(
                .rotation(
                    from: oldValue ? .pi / 2 : 0,
                    to: !oldValue ? .pi / 2 : 0
                ),
                duration: 2,
                applyingResult: true,
                continueFromCurrent: true
            )
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(cross: .stretch) {
            exampleNode
            buttonNode
        }
    }

    override func configureTheme(_ theme: VATheme) {
        exampleNode.backgroundColor = theme.systemPink
    }

    override func bind() {
        buttonNode.onTap = self ?> { $0.isToggled.toggle() }
    }
}

private class _ScaleAnimationExampleNode: DisplayNode, @unchecked Sendable {
    private lazy var exampleNode = VADisplayNode()
        .sized(height: 20)
    private lazy var  buttonNode = HapticButtonNode(title: "Toggle scale")
    private var isToggled = false {
        didSet {
            exampleNode.animate(
                .scale(
                    from: oldValue ? 1.1 : 1,
                    to: !oldValue ? 1.1 : 1
                ),
                duration: 2,
                applyingResult: true,
                continueFromCurrent: true
            )
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(cross: .stretch) {
            exampleNode
            buttonNode
        }
    }

    override func configureTheme(_ theme: VATheme) {
        exampleNode.backgroundColor = theme.systemGreen
    }

    override func bind() {
        buttonNode.onTap = self ?> { $0.isToggled.toggle() }
    }
}

private class _ColorAnimationExampleNode: DisplayNode, @unchecked Sendable {
    private lazy var exampleNode = VADisplayNode()
        .sized(height: 20)
    private lazy var buttonNode = HapticButtonNode(title: "Toggle color")
    private var isToggled = false {
        didSet {
            exampleNode.animate(
                .backgroundColor(
                    from: oldValue ? theme.systemIndigo : theme.systemRed,
                    to: !oldValue ? theme.systemIndigo : theme.systemRed
                ),
                duration: 2,
                continueFromCurrent: true
            )
            exampleNode.backgroundColor = !oldValue ? theme.systemIndigo : theme.systemRed
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(cross: .stretch) {
            exampleNode
            buttonNode
        }
    }

    override func configureTheme(_ theme: VATheme) {
        exampleNode.backgroundColor = isToggled ? theme.systemIndigo : theme.systemRed
    }

    override func bind() {
        buttonNode.onTap = self ?> { $0.isToggled.toggle() }
    }
}

private class _OpacityAnimationExampleNode: DisplayNode, @unchecked Sendable {
    private lazy var exampleNode = VADisplayNode()
        .sized(height: 20)
    private lazy var buttonNode = HapticButtonNode(title: "Toggle opacity")
    private var isToggled = false {
        didSet {
            exampleNode.animate(
                .opacity(
                    from: oldValue ? 0 : 1,
                    to: !oldValue ? 0 : 1
                ),
                duration: 2,
                applyingResult: true,
                continueFromCurrent: true
            )
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(cross: .stretch) {
            exampleNode
            buttonNode
        }
    }

    override func configureTheme(_ theme: VATheme) {
        exampleNode.backgroundColor = theme.systemOrange
    }

    override func bind() {
        buttonNode.onTap = self ?> { $0.isToggled.toggle() }
    }
}

private class _BoundsAnimationExampleNode: DisplayNode, @unchecked Sendable {
    private lazy var heightNode = VADisplayNode()
        .sized(width: 100, height: isToggled ? 100 : 20)
    private lazy var widthNode = VADisplayNode()
        .sized(width: isToggled ? 20 : 100, height: 20)
    private lazy var boundsNode = VADisplayNode()
        .sized(.init(same: 20))
        .apply {
            $0.anchorPoint = .zero
        }
    private lazy var buttonNode = HapticButtonNode(title: "Toggle Bounds")
    private var isToggled = false {
        didSet {
            boundsNode.animate(
                .bounds(
                    from: oldValue ? CGRect(origin: .zero, size: .init(same: 100)) : CGRect(origin: .zero, size: .init(same: 20)),
                    to: !oldValue ? CGRect(origin: .zero, size: .init(same: 100)) : CGRect(origin: .zero, size: .init(same: 20))
                ),
                duration: defaultLayoutTransitionDuration,
                removeOnCompletion: false,
                spring: .init(initialVelocity: 100, damping: 200, mass: 10, swiftness: 2000)
            )
            heightNode.style.height = .points(isToggled ? 100 : 20)
            widthNode.style.width = .points(isToggled ? 20 : 100)
            setNeedsLayoutAnimated(withSupernode: true)
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(cross: .stretch) {
            Row(spacing: 8) {
                heightNode
                widthNode
                boundsNode
            }
            buttonNode
        }
    }

    override func viewDidAnimateLayoutTransition(_ context: any ASContextTransitioning) {
        animateLayoutTransition(context: context)
    }

    override func configureTheme(_ theme: VATheme) {
        heightNode.backgroundColor = theme.systemPurple
        widthNode.backgroundColor = theme.systemPurple
        boundsNode.backgroundColor = theme.systemPurple
    }

    override func bind() {
        buttonNode.onTap = self ?> { $0.isToggled.toggle() }
    }
}
