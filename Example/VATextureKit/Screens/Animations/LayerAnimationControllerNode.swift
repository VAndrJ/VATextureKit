//
//  LayerAnimationControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 21.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct LayerAnimationNavigationIdentity: DefaultNavigationIdentity {}

final class LayerAnimationControllerNode: VASafeAreaDisplayNode {
    private lazy var boundsAnimationExampleNode = BoundsAnimationExampleNode()
    private lazy var opacityAnimationExampleNode = OpacityAnimationExampleNode()
    private lazy var scaleAnimationExampleNode = ScaleAnimationExampleNode()
    private lazy var rotationAnimationExampleNode = RotationAnimationExampleNode()
    private lazy var cornerRadiusAnimationExampleNode = CornerRadiusAnimationExampleNode()
    private lazy var colorAnimationExampleNode = ColorAnimationExampleNode()
    private lazy var scrollNode = VAScrollNode(data: .init())

    init() {
        super.init()

        scrollNode.layoutSpecBlock = { [weak self] in
            self?.scrollLayoutSpecThatFits($1) ?? ASLayoutSpec()
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            scrollNode
        }
    }

    private func scrollLayoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
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

private class CornerRadiusAnimationExampleNode: VADisplayNode {
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

    override func didLoad() {
        super.didLoad()

        bind()
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

    private func bind() {
        buttonNode.onTap = self ?> { $0.isToggled.toggle() }
    }
}

private class RotationAnimationExampleNode: VADisplayNode {
    private lazy var exampleNode = VAImageNode(
        image: R.image.chevron_right(),
        size: CGSize(same: 50),
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

    override func didLoad() {
        super.didLoad()

        bind()
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

    private func bind() {
        buttonNode.onTap = self ?> { $0.isToggled.toggle() }
    }
}

private class ScaleAnimationExampleNode: VADisplayNode {
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

    override func didLoad() {
        super.didLoad()

        bind()
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

    private func bind() {
        buttonNode.onTap = self ?> { $0.isToggled.toggle() }
    }
}

private class ColorAnimationExampleNode: VADisplayNode {
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

    override func didLoad() {
        super.didLoad()

        bind()
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

    private func bind() {
        buttonNode.onTap = self ?> { $0.isToggled.toggle() }
    }
}

private class OpacityAnimationExampleNode: VADisplayNode {
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

    override func didLoad() {
        super.didLoad()

        bind()
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

    private func bind() {
        buttonNode.onTap = self ?> { $0.isToggled.toggle() }
    }
}

private class BoundsAnimationExampleNode: VADisplayNode {
    private lazy var heightNode = VADisplayNode()
        .sized(width: 100, height: isToggled ? 100 : 20)
    private lazy var widthNode = VADisplayNode()
        .sized(width: isToggled ? 20 : 100, height: 20)
    private lazy var boundsNode = VADisplayNode()
        .sized(CGSize(same: 20))
        .apply {
            $0.anchorPoint = .zero
        }
    private lazy var buttonNode = HapticButtonNode(title: "Toggle Bounds")
    private var isToggled = false {
        didSet {
            boundsNode.animate(
                .bounds(
                    from: oldValue ? CGRect(origin: .zero, size: CGSize(same: 100)) : CGRect(origin: .zero, size: CGSize(same: 20)),
                    to: !oldValue ? CGRect(origin: .zero, size: CGSize(same: 100)) : CGRect(origin: .zero, size: CGSize(same: 20))
                ),
                duration: defaultLayoutTransitionDuration,
                removeOnCompletion: false,
                spring: .init(initialVelocity: 100, damping: 200, mass: 10, swiftness: 2000)
            )
            heightNode.style.height = .points(isToggled ? 100 : 20)
            widthNode.style.width = .points(isToggled ? 20 : 100)
            setNeedsLayoutAnimated(isWithSupernodes: true)
        }
    }

    override func didLoad() {
        super.didLoad()

        bind()
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

    @MainActor
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        animateLayoutTransition(context: context)
    }

    override func configureTheme(_ theme: VATheme) {
        heightNode.backgroundColor = theme.systemPurple
        widthNode.backgroundColor = theme.systemPurple
        boundsNode.backgroundColor = theme.systemPurple
    }

    private func bind() {
        buttonNode.onTap = self ?> { $0.isToggled.toggle() }
    }
}
