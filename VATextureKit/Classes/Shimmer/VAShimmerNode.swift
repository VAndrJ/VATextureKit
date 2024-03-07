//
//  VAShimmerNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 19.07.2023.
//

import AsyncDisplayKit

open class VAShimmerNode: VADisplayNode {
    public struct Context {
        let isAcrossWindow: Bool
        let isSynchronized: Bool
        let animationDuration: CFTimeInterval
        let maskLayer: () -> CAGradientLayer
        let animation: (_ layer: CALayer, _ duration: CFTimeInterval, _ timeOffset: CFTimeInterval) -> CABasicAnimation

        public init(
            isAcrossWindow: Bool = true,
            isSynchronized: Bool = true,
            animationDuration: CFTimeInterval = 1.5,
            maskLayer: @escaping () -> CAGradientLayer = {
                let gradient = CAGradientLayer()
                gradient.startPoint = CGPoint(x: 0, y: 0.5)
                gradient.endPoint = CGPoint(x: 1, y: 0.5)
                gradient.locations = [0.4, 0.5, 0.6]
                let colors: [UIColor] = [
                    .black,
                    .black.withAlphaComponent(0.16),
                    .black,
                ]
                gradient.colors = colors.map(\.cgColor)

                return gradient
            },
            animation: @escaping (_ layer: CALayer, _ duration: CFTimeInterval, _ timeOffset: CFTimeInterval) -> CABasicAnimation = { layer, duration, timeOffset in
                return layer.getAnimation(
                    .locations(
                        from: [0.0, 0.05, 0.1],
                        to: [0.9, 0.95, 1.0]
                    ),
                    duration: duration,
                    timeOffset: timeOffset,
                    repeatCount: .greatestFiniteMagnitude,
                    removeOnCompletion: false
                )
            }
        ) {
            self.isAcrossWindow = isAcrossWindow
            self.isSynchronized = isSynchronized
            self.animationDuration = animationDuration
            self.maskLayer = maskLayer
            self.animation = animation
        }
    }

    let data: Context
    private(set) lazy var maskLayer: CAGradientLayer = data.maskLayer()

    public init(data: Context) {
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
            let convertedOriginX = window.convert(view.bounds.origin, from: view).x
            maskLayer.frame = getMaskFrame(for: windowBounds, originXDelta: convertedOriginX)
        } else if data.isAcrossWindow, let controller = closestViewController {
            let controllerViewBounds = controller.view.bounds
            let convertedOriginX = controller.view.convert(view.bounds.origin, from: view).x
            maskLayer.frame = getMaskFrame(for: controllerViewBounds, originXDelta: convertedOriginX)
        } else {
            maskLayer.frame = getMaskFrame(for: bounds, originXDelta: 0)
        }
        updateShimmer()
    }

    private func getMaskFrame(for bounds: CGRect, originXDelta: CGFloat) -> CGRect {
        CGRect(
            x: -(bounds.width * 1.5 + originXDelta),
            y: 0,
            width: 4 * bounds.width,
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
        maskLayer.removeAllAnimations()
        layer.mask = maskLayer
        let timeOffset = data.isSynchronized ? Date.timeIntervalSinceReferenceDate.remainder(dividingBy: data.animationDuration) : 0
        let animation = data.animation(maskLayer, data.animationDuration, timeOffset)
        maskLayer.add(animation, forKey: animation.keyPath)
    }

    private func endShimmering() {
        maskLayer.removeAllAnimations()
        layer.mask = nil
    }
}
