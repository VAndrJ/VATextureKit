//
//  LayerAnimationControllerNode.swift
//  VATextureKit_Example
//
//  Created by VAndrJ on 21.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class LayerAnimationControllerNode: VASafeAreaDisplayNode {
    let opacityNode = VADisplayNode()
        .sized(height: 20)
    let opacityButtonNode = HapticButtonNode()
    var isTransparent = false {
        didSet {
            opacityNode.animate(.opacity(
                from: oldValue ? 0 : 1,
                to: oldValue ? 1 : 0,
                duration: 1,
                removeOnCompletion: false
            ))
        }
    }
    let scaleNode = VADisplayNode()
        .sized(height: 20)
    let scaleButtonNode = HapticButtonNode()
    var isScaled = false {
        didSet {
            scaleNode.animate(.scale(
                from: oldValue ? 1.1 : 1,
                to: oldValue ? 1 : 1.1,
                duration: 1,
                removeOnCompletion: false
            ))
        }
    }

    let heightNode = VADisplayNode()
        .sized(width: 100, height: 20)
    let widthNode = VADisplayNode()
        .sized(width: 100, height: 20)
    let boundsNode = VADisplayNode()
        .sized(CGSize(same: 20))
        .apply {
            $0.anchorPoint = .zero
        }
    let boundsButtonNode = HapticButtonNode()
    var isBoundsChanged = false {
        didSet {
            boundsNode.animate(.bounds(
                from: oldValue ? CGRect(origin: .zero, size: CGSize(same: 100)) : CGRect(origin: .zero, size: CGSize(same: 20)),
                to: oldValue ? CGRect(origin: .zero, size: CGSize(same: 20)) : CGRect(origin: .zero, size: CGSize(same: 100)),
                duration: defaultLayoutTransitionDuration,
                removeOnCompletion: false
            ))
            setNeedsLayoutAnimated()
        }
    }

    let rotationNode = VAImageNode(data: .init(
        image: R.image.chevron_right(),
        tintColor: { $0.darkText },
        size: CGSize(same: 50),
        contentMode: .center
    ))
    let rotationButtonNode = HapticButtonNode()
    var isRotated = false {
        didSet {
            rotationNode.animate(.rotation(
                from: oldValue ? .pi / 2 : 0,
                to: oldValue ? 0 : .pi / 2,
                duration: 1,
                removeOnCompletion: false
            ))
        }
    }

    let pulseNode = VADisplayNode()
        .sized(width: 200, height: 20)
    let pulseButtonNode = HapticButtonNode()

    let shakeXNode = VADisplayNode()
        .sized(width: 100, height: 20)
    let shakeYNode = VADisplayNode()
        .sized(width: 100, height: 20)
    let shakeButtonNode = HapticButtonNode()

    let cornerRadiusNode = VADisplayNode()
        .sized(width: 100, height: 20)
    let cornerRadiusButtonNode = HapticButtonNode()
    var isCornersRounded = false {
        didSet {
            cornerRadiusNode.animate(.cornerRadius(
                from: oldValue ? 10 : 0,
                to: oldValue ? 0 : 10,
                duration: 1,
                continueFromCurrent: true
            ))
            cornerRadiusNode.cornerRadius = isCornersRounded ? 10 : 0
        }
    }

    override func didLoad() {
        super.didLoad()

        bind()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(cross: .stretch) {
                opacityNode
                opacityButtonNode
                    .padding(.bottom(16))

                scaleNode
                scaleButtonNode
                    .padding(.bottom(16))

                Row(spacing: 8) {
                    heightNode
                        .sized(height: isBoundsChanged ? 100 : 20)
                    widthNode
                        .sized(width: isBoundsChanged ? 20 : 100)
                    boundsNode
                }
                boundsButtonNode
                    .padding(.bottom(16))

                rotationNode
                rotationButtonNode
                    .padding(.bottom(16))

                Row(main: .center) {
                    pulseNode
                }
                pulseButtonNode
                    .padding(.bottom(16))

                Row(main: .spaceAround) {
                    shakeXNode
                    shakeYNode
                }
                shakeButtonNode
                    .padding(.bottom(16))

                cornerRadiusNode
                cornerRadiusButtonNode
                    .padding(.bottom(16))
            }
            .padding(.all(16))
        }
    }

    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        animateLayoutTransition(context: context)
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
        opacityNode.backgroundColor = theme.systemOrange
        opacityButtonNode.tintColor = theme.systemBlue
        opacityButtonNode.configure(title: "Animate opacity", theme: theme)

        scaleNode.backgroundColor = theme.systemGreen
        scaleButtonNode.tintColor = theme.systemBlue
        scaleButtonNode.configure(title: "Animate scale", theme: theme)

        heightNode.backgroundColor = theme.systemPurple
        widthNode.backgroundColor = theme.systemPurple
        boundsNode.backgroundColor = theme.systemPurple
        boundsButtonNode.tintColor = theme.systemBlue
        boundsButtonNode.configure(title: "Animate Bounds", theme: theme)

        rotationNode.backgroundColor = theme.systemPink
        rotationButtonNode.tintColor = theme.systemBlue
        rotationButtonNode.configure(title: "Animate rotation", theme: theme)

        pulseNode.backgroundColor = theme.systemTeal
        pulseButtonNode.tintColor = theme.systemBlue
        pulseButtonNode.configure(title: "Animate pulse", theme: theme)

        shakeXNode.backgroundColor = theme.systemIndigo
        shakeYNode.backgroundColor = theme.systemIndigo
        shakeButtonNode.tintColor = theme.systemBlue
        shakeButtonNode.configure(title: "Animate shake", theme: theme)

        cornerRadiusNode.backgroundColor = theme.systemGray
        cornerRadiusButtonNode.tintColor = theme.systemBlue
        cornerRadiusButtonNode.configure(title: "Animate corner radius", theme: theme)
    }

    private func bind() {
        opacityButtonNode.onTap = self ?> { $0.isTransparent.toggle() }
        scaleButtonNode.onTap = self ?> { $0.isScaled.toggle() }
        boundsButtonNode.onTap = self ?> { $0.isBoundsChanged.toggle() }
        rotationButtonNode.onTap = self ?> { $0.isRotated.toggle() }
        pulseButtonNode.onTap = pulseNode ?> {
            $0.animate(.scale(values: [1, 1.1, 0.9, 1.2, 0.8, 1.1, 0.9, 1], duration: 1))
        }
        shakeButtonNode.onTap = self ?> {
            $0.shakeXNode.animate(.positionX(
                values: [0, -10, +10, -20, +20, -10, +10, 0] + $0.shakeXNode.position.x,
                duration: 0.5
            ))
            $0.shakeYNode.animate(.positionY(
                values: [0, -10, +10, -20, +20, -10, +10, 0] + $0.shakeYNode.position.y,
                duration: 1
            ))
        }
        cornerRadiusButtonNode.onTap = self ?> { $0.isCornersRounded.toggle() }
    }
}
