//
//  VAComparisonNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 06.04.2024.
//

import AsyncDisplayKit
import VATextureKitSpec

open class VAComparisonNode: VADisplayNode {
    public enum Order {
        case first
        case second
    }

    public enum Divider {
        case standard(configuration: DividerConfiguration = .standard)
        case custom(CALayer)

        var width: CGFloat {
            switch self {
            case let .standard(configuration): configuration.width
            case let .custom(layer): layer.frame.width
            }
        }
    }

    public struct DividerConfiguration {
        public static var standard: Self { .init(width: 2, color: .white) }

        public let width: CGFloat
        public let color: UIColor

        public init(width: CGFloat, color: UIColor) {
            self.width = width
            self.color = color
        }
    }

    public var divider: Divider? = .standard() {
        didSet { updateDivider() }
    }
    public private(set) var dividerLayer: CALayer?
    public let firstNode: ASDisplayNode
    public let secondNode: ASDisplayNode
    public let maskLayer = CALayer()
    public private(set) var dividerPosition: CGFloat = 0.5 {
        didSet { updateMaskFrame() }
    }
    public var isShowBoth = false {
        didSet { showBothIfNeeded() }
    }

    public init(
        firstNode: ASDisplayNode,
        secondNode: ASDisplayNode,
        corner: VACornerRoundingParameters = .default
    ) {
        self.firstNode = firstNode
        self.secondNode = secondNode

        super.init(corner: corner)
    }

    open override func didLoad() {
        super.didLoad()

        layer.masksToBounds = true
        firstNode.layer.mask = maskLayer
        configure()
        bind()
    }

    open override func layout() {
        super.layout()

        updateMaskFrame(isLayout: true)
    }

    open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Stack {
            secondNode
                .sized(constrainedSize.max)
            firstNode
                .sized(constrainedSize.max)
        }
    }

    private func updateDivider() {
        dividerLayer?.removeFromSuperlayer()
        dividerLayer = nil
        if let divider {
            switch divider {
            case let .standard(configuration):
                let dividerLayer = CALayer()
                dividerLayer.backgroundColor = configuration.color.cgColor
                self.layer.addSublayer(dividerLayer)
                self.dividerLayer = dividerLayer
            case let .custom(layer):
                self.layer.addSublayer(layer)
                self.dividerLayer = layer
            }
            updateDividerFrame()
        }
    }

    private func updateMaskFrame(isLayout: Bool = false) {
        let width = dividerPosition * bounds.width
        let newRect = CGRect(x: 0, y: 0, width: width, height: bounds.height)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        animateIfNeeded(isLayout: isLayout, layer: maskLayer, newFrame: newRect)
        maskLayer.frame = newRect
        CATransaction.commit()
        updateDividerFrame(isLayout: isLayout)
    }

    private func updateDividerFrame(isLayout: Bool = false) {
        guard let dividerLayer, let divider else { return }

        let width = dividerPosition * bounds.width
        let newRect = CGRect(x: width - divider.width / 2, y: 0, width: divider.width, height: bounds.height)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        animateIfNeeded(isLayout: isLayout, layer: dividerLayer, newFrame: newRect)
        dividerLayer.frame = newRect
        CATransaction.commit()
    }

    private func animateIfNeeded(isLayout: Bool, layer: CALayer, newFrame: CGRect) {
        if isLayout, let referenceAnimation = self.layer.presentation()?.animation(forKey: "bounds.size") {
            let sizeAnimation = getAnimation(
                keyPath: "bounds.size",
                from: layer.bounds.size,
                to: newFrame.size,
                reference: referenceAnimation
            )
            layer.add(sizeAnimation, forKey: sizeAnimation.keyPath)
            let positionAnimation = getAnimation(
                keyPath: "position",
                from: layer.position,
                to: CGPoint(x: newFrame.midX, y: newFrame.midY),
                reference: referenceAnimation
            )
            layer.add(positionAnimation, forKey: positionAnimation.keyPath)
        }
    }

    private func bind() {
        view.addGestureRecognizer(UIPanGestureRecognizer(
            target: self,
            action: #selector(onPan(_:))
        ))
        let tapWithTwoFingersGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(onTapWithTwoFingers(_:))
        )
        tapWithTwoFingersGesture.numberOfTouchesRequired = 2
        view.addGestureRecognizer(tapWithTwoFingersGesture)
    }

    @objc private func onPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            dividerPosition = max(0, min(1, dividerPosition + sender.translation(in: view).x / bounds.width))
            sender.setTranslation(.zero, in: view)
        default:
            break
        }
    }

    @objc private func onTapWithTwoFingers(_ sender: UITapGestureRecognizer) {
        guard sender.state == .recognized else { return }

        isShowBoth.toggle()
    }

    open func showBothIfNeeded() {
        if isShowBoth {
            dividerLayer?.opacity = 0
            firstNode.layer.mask = nil
            firstNode.alpha = 0.5
        } else {
            dividerLayer?.opacity = 1
            firstNode.layer.mask = maskLayer
            firstNode.alpha = 1
        }
    }

    private func configure() {
        isUserInteractionEnabled = true
        maskLayer.backgroundColor = UIColor.black.cgColor
        updateDivider()
    }
}

private func getAnimation(
    keyPath: String,
    from: Any,
    to: Any,
    reference: CAAnimation
) -> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: keyPath)
    animation.fromValue = from
    animation.toValue = to
    animation.duration = reference.duration
    animation.timingFunction = reference.timingFunction
    animation.fillMode = reference.fillMode
    if #available(iOS 15.0, *) {
        animation.preferredFrameRateRange = reference.preferredFrameRateRange
    }

    return animation
}
