//
//  KeyframeAnimationsScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 30.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct KeyframeAnimationsNavigationIdentity: DefaultNavigationIdentity {}

final class KeyframeAnimationsScreenNode: ScrollScreenNode {
    private lazy var shakeAnimationExampleNode = _ShakeAnimationExampleNode()
    private lazy var shakeAnimationPauseResumeExampleNode = _ShakeAnimationPauseResumeExampleNode()
    private lazy var animationExampleNodes = [
        _AnimationExampleNode(animation: .scale(values: [1, 1.1, 0.9, 1.2, 0.8, 1.1, 0.9, 1])),
        _AnimationExampleNode(animation: .opacity(values: [1, 0.9, 0.8, 0.1, 0, 0.2, 0.9, 1, 0, 1])),
        _AnimationExampleNode(animation: .backgroundColor(values: [theme.systemOrange, .green, .blue, .black, theme.systemOrange])),
        _AnimationExampleNode(animation: .borderColor(values: [.black, theme.systemOrange, .green, .blue, .clear, theme.systemOrange, .black])),
        _AnimationExampleNode(animation: .borderWidth(values: [2, 0, 10, 0, 5, 2])),
        _AnimationExampleNode(animation: .cornerRadius(values: [0, 15, 5, 15, 0])),
        _AnimationExampleNode(animation: .scaleX(values: [1, 1.1, 0.9, 1.1, 1])),
        _AnimationExampleNode(animation: .scaleY(values: [1, 1.1, 0.9, 1.1, 1])),
        _AnimationExampleNode(animation: .shadowColor(values: [theme.systemOrange, .black, .green, .blue, theme.systemOrange])),
        _AnimationExampleNode(animation: .shadowOffset(values: [.zero, .init(same: 5), .init(same: -5), .init(width: 5, height: -5), .init(width: -5, height: 5), .zero])),
        _AnimationExampleNode(animation: .shadowRadius(values: [4, 20, 0, 10, 4])),
        _AnimationExampleNode(animation: .shadowOpacity(values: [1, 0, 1, 0, 1])),
        _AnimationExampleNode(animation: .rotation(values: [0, .pi / 16, -.pi / 32, .pi / 64, -.pi / 128, .pi / 256, -.pi / 512, 0])),
        _GradientAnimationExampleNode(animation: .locations(values: [
            [0, 1],
            [0, 0.3],
            [0.3, 1],
            [0.7, 1],
            [0, 0.3],
            [0, 1],
        ])),
        _GradientAnimationExampleNode(animation: .colors(values: [
            [theme.systemOrange, theme.systemIndigo],
            [theme.systemGreen, theme.systemBlue],
            [theme.systemRed, theme.label],
            [theme.systemOrange, theme.systemIndigo],
        ])),
        _GradientAnimationExampleNode(animation: .startPoint(values: [
            CGPoint(x: 0, y: 0.5),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 0.5, y: 1),
            CGPoint(xy: 0.5),
            CGPoint(x: 0, y: 0.5),
        ])),
        _GradientAnimationExampleNode(animation: .endPoint(values: [
            CGPoint(x: 1, y: 0.5),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 0.5, y: 1),
            CGPoint(xy: 0.5),
            CGPoint(x: 1, y: 0.5),
        ])),
    ]

    override func scrollLayoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 16, cross: .stretch) {
            shakeAnimationExampleNode
            shakeAnimationPauseResumeExampleNode
            animationExampleNodes
        }
        .padding(.all(16))
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
}

private class _ShakeAnimationPauseResumeExampleNode: DisplayNode {
    private lazy var shakeXNode = VADisplayNode()
        .sized(width: 100, height: 30)
    private lazy var buttonNode = HapticButtonNode(title: "Animate shake")
    private lazy var pauseButtonNode = HapticButtonNode(title: "Pause")
    private lazy var resumeButtonNode = HapticButtonNode(title: "Resume")
    private var isToggled = false {
        didSet {
            setNeedsLayout()
            shakeXNode.animate(
                .positionX(values: [0, -100, 0, +100, 0] + shakeXNode.position.x),
                duration: 2,
                repeatCount: .greatestFiniteMagnitude,
                autoreverses: true
            )
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(cross: .center) {
            shakeXNode
            if isToggled {
                Row(spacing: 32) {
                    pauseButtonNode
                    resumeButtonNode
                }
            } else {
                buttonNode
            }
        }
    }

    override func configureTheme(_ theme: VATheme) {
        shakeXNode.backgroundColor = theme.label
    }

    override func bind() {
        buttonNode.onTap = self ?> { $0.isToggled = true }
        pauseButtonNode.onTap = self ?>> { $0.shakeXNode.pauseAnimations }
        resumeButtonNode.onTap = self ?>> { $0.shakeXNode.resumeAnimations }
    }
}

private class _ShakeAnimationExampleNode: DisplayNode {
    private lazy var shakeXNode = VADisplayNode()
        .sized(width: 100, height: 30)
    private lazy var shakeYNode = VADisplayNode()
        .sized(width: 100, height: 30)
    private lazy var buttonNode = HapticButtonNode(title: "Animate shake")

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(cross: .stretch) {
            Row(main: .spaceAround) {
                shakeXNode
                shakeYNode
            }
            buttonNode
        }
    }

    override func configureTheme(_ theme: VATheme) {
        shakeXNode.backgroundColor = theme.systemIndigo
        shakeYNode.backgroundColor = theme.systemIndigo
    }

    override func bind() {
        buttonNode.onTap = self ?> {
            $0.shakeXNode.animate(
                .positionX(values: [0, -10, +10, -20, +20, -10, +10, 0] + $0.shakeXNode.position.x),
                duration: 0.5
            )
            $0.shakeYNode.animate(
                .positionY(values: [0, -10, +10, -20, +20, -10, +10, 0] + $0.shakeYNode.position.y),
                duration: 1
            )
        }
    }
}

private class _AnimationExampleNode: DisplayNode {
    private lazy var exampleNode = VADisplayNode()
        .sized(width: 300, height: 30)
        .apply {
            $0.borderWidth = 2
            $0.shadowRadius = 4
            $0.shadowOffset = .zero
            $0.shadowOpacity = 1
        }
    private lazy var buttonNode = HapticButtonNode(title: "Animate \(animation.keyPath)")
    private var animation: CALayer.VALayerKeyframeAnimation

    init(animation: CALayer.VALayerKeyframeAnimation) {
        self.animation = animation

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(cross: .stretch) {
            Row(main: .center) {
                exampleNode
            }
            buttonNode
        }
    }

    override func configureTheme(_ theme: VATheme) {
        exampleNode.backgroundColor = theme.systemOrange
        exampleNode.shadowColor = theme.systemOrange.cgColor
    }

    override func bind() {
        buttonNode.onTap = self ?> { $0.exampleNode.animate($0.animation, duration: 2) }
    }
}

private class _GradientAnimationExampleNode: DisplayNode {
    private lazy var exampleNode = VALinearGradientNode(gradient: .horizontal)
        .sized(width: 300, height: 30)
    private lazy var buttonNode = HapticButtonNode(title: "Animate \(animation.keyPath)")
    private var animation: CALayer.VALayerKeyframeAnimation

    init(animation: CALayer.VALayerKeyframeAnimation) {
        self.animation = animation

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(cross: .stretch) {
            Row(main: .center) {
                exampleNode
            }
            buttonNode
        }
    }

    override func configureTheme(_ theme: VATheme) {
        exampleNode.update(colors: (theme.systemOrange, 0), (theme.systemIndigo, 1))
    }

    override func bind() {
        buttonNode.onTap = self ?> { $0.exampleNode.animate($0.animation, duration: 2) }
    }
}
