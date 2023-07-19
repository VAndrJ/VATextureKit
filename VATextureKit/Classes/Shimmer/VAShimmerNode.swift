//
//  VAShimmerNode.swift
//  VATextureKit
//
//  Created by VAndrJ on 19.07.2023.
//

import AsyncDisplayKit

open class VAShimmerNode: VADisplayNode {
    public struct DTO {
        let isAcrossWindow: Bool
        let isSynchronized: Bool
        let animationDuration: CFTimeInterval
        let maskLayer: () -> CAGradientLayer
        let animation: (_ duration: CFTimeInterval, _ timeOffset: CFTimeInterval) -> CABasicAnimation

        public init(
            isAcrossWindow: Bool = true,
            isSynchronized: Bool = true,
            animationDuration: CFTimeInterval = 1,
            maskLayer: @escaping () -> CAGradientLayer = {
                let gradient = CAGradientLayer()
                gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
                gradient.locations = [0.4, 0.5, 0.6]
                let colors: [UIColor] = [
                    .black.withAlphaComponent(0.18),
                    .black.withAlphaComponent(0.1),
                    .black.withAlphaComponent(0.18),
                ]
                gradient.colors = colors.map(\.cgColor)
                return gradient
            },
            animation: @escaping (_ duration: CFTimeInterval, _ timeOffset: CFTimeInterval) -> CABasicAnimation = { duration, timeOffset in
                let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
                animation.fromValue = [0.0, 0.1, 0.2]
                animation.toValue = [0.8, 0.9, 1.0]
                animation.timeOffset = timeOffset
                animation.duration = duration
                animation.repeatCount = .greatestFiniteMagnitude
                animation.isRemovedOnCompletion = false
                return animation
            }
        ) {
            self.isAcrossWindow = isAcrossWindow
            self.isSynchronized = isSynchronized
            self.animationDuration = animationDuration
            self.maskLayer = maskLayer
            self.animation = animation
        }
    }

    let data: DTO
    private(set) lazy var maskLayer: CAGradientLayer = data.maskLayer()

    public init(data: DTO) {
        self.data = data

        super.init()
    }

    public override func didEnterVisibleState() {
        super.didEnterVisibleState()

        updateShimmer()
    }

    public override func didExitVisibleState() {
        super.didExitVisibleState()

        updateShimmer()
    }

    public override func layout() {
        super.layout()

        if data.isAcrossWindow, let window = view.window {
            let windowBounds = window.bounds
            let convertedOriginX = window.convert(view.frame.origin, from: view).x
            maskLayer.frame = getMaskFrame(for: windowBounds, originXDelta: convertedOriginX)
        } else if data.isAcrossWindow, let controller = closestViewController {
            let controllerViewBounds = controller.view.bounds
            let convertedOriginX = controller.view.convert(view.frame.origin, from: view).x
            maskLayer.frame = getMaskFrame(for: controllerViewBounds, originXDelta: convertedOriginX)
        } else {
            maskLayer.frame = getMaskFrame(for: bounds, originXDelta: 0)
        }
        updateShimmer()
    }

    private func getMaskFrame(for bounds: CGRect, originXDelta: CGFloat) -> CGRect {
        CGRect(
            x: -(bounds.width + originXDelta),
            y: 0,
            width: 3 * bounds.width,
            height: bounds.height
        )
    }

    private func updateShimmer() {
        if isVisible {
            startShimmering()
        } else {
            endShimmering()
        }
    }

    private func startShimmering() {
        layer.mask = maskLayer
        let timeOffset = data.isSynchronized ? Date().timeIntervalSince1970.remainder(dividingBy: data.animationDuration) : 0
        let animation = data.animation(data.animationDuration, timeOffset)

        maskLayer.add(animation, forKey: animation.keyPath)
    }

    private func endShimmering() {
        maskLayer.removeAllAnimations()
        layer.mask = nil
    }
}
