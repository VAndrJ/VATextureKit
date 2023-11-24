//
//  VATransionAnimator.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 26.07.2023.
//

import AsyncDisplayKit

public protocol VATransionAnimator {
    static var animationDuration: TimeInterval { get set }

    var controller: UIViewController? { get }

    func animateTransition(source: UIViewController?, destination: UIViewController?, animated: Bool, isPresenting: Bool)
    func addTransitionOverlayView() -> UIView
}

open class VADefaultTransionAnimator: VATransionAnimator {
    public static var animationDuration: TimeInterval = 0.5

    public private(set) weak var controller: UIViewController?

    public init(controller: UIViewController?) {
        self.controller = controller
    }

    public func animateTransition(
        source: UIViewController?,
        destination: UIViewController?,
        animated: Bool,
        isPresenting: Bool
    ) {
        guard animated, let source, let destination else {
            return
        }
        guard isPresenting ? destination.isTransitionAnimationEnabled : source.isTransitionAnimationEnabled else {
            return
        }
        guard let sourceController = (source as? ASDKViewController) ?? ((source as? UINavigationController)?.topViewController as? ASDKViewController) ?? ((source as? UITabBarController)?.selectedViewController as? ASDKViewController) ?? (((source as? UITabBarController)?.selectedViewController as? UINavigationController)?.topViewController as? ASDKViewController), let destinationController = (destination as? ASDKViewController) ?? ((destination as? UINavigationController)?.topViewController as? ASDKViewController) ?? ((destination as? UITabBarController)?.selectedViewController as? ASDKViewController) ?? (((destination as? UITabBarController)?.selectedViewController as? UINavigationController)?.topViewController as? ASDKViewController) else {
            return
        }

        var fromLayersDict: [String: (CALayer, CGRect)] = [:]
        storeAnimationLayers(layer: sourceController.node.layer, isFrom: true, to: &fromLayersDict)
        guard !fromLayersDict.isEmpty else {
            return
        }

        if isPresenting {
            destinationController.node.loadForPreview()
        }
        destinationController.node.layer.isHidden = true
        // MARK: - Crutch to get proper target layout on push
        mainAsync(after: 0.01) { [self] in
            var toLayersDict: [String: (CALayer, CGRect)] = [:]
            storeAnimationLayers(layer: destinationController.node.layer, isFrom: false, to: &toLayersDict)
            animateLayers(
                fromLayersDict: fromLayersDict,
                toLayersDict: toLayersDict,
                transitionOverlayView: addTransitionOverlayView(),
                animationDuration: Self.animationDuration
            )
            destinationController.node.layer.isHidden = false
        }
    }

    public func addTransitionOverlayView() -> UIView {
        let transitionOverlayView = VATouchesPassThroughView()
        controller?.view.window?.addSubview(transitionOverlayView)
        transitionOverlayView.frame = controller?.view.frame ?? .zero

        return transitionOverlayView
    }
}

public class VATouchesPassThroughView: UIView {

    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        false
    }
}

private func animateLayers(fromLayersDict: [String: (CALayer, CGRect)], toLayersDict: [String: (CALayer, CGRect)], transitionOverlayView: UIView, animationDuration: TimeInterval) {
    if !(fromLayersDict.isEmpty || toLayersDict.isEmpty) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            transitionOverlayView.removeFromSuperview()
        }
        for key in fromLayersDict.keys {
            if let from = fromLayersDict[key], let to = toLayersDict[key] {
                animate(from: from, to: to, in: transitionOverlayView, animationDuration: animationDuration)
            }
        }
        CATransaction.commit()
    } else {
        transitionOverlayView.removeFromSuperview()
    }
}

private func storeAnimationLayers(layer: CALayer, isFrom: Bool, to: inout [String: (CALayer, CGRect)]) {
    if let id = layer.transitionAnimationId {
        if isFrom, let node = (layer.delegate as? _ASDisplayView)?.asyncdisplaykit_node {
            if node.isVisible {
                to[id] = (layer, layer.convert(layer.bounds, to: nil))
            }
        } else {
            to[id] = (layer, layer.convert(layer.bounds, to: nil))
        }
    }
    layer.sublayers?.forEach { storeAnimationLayers(layer: $0, isFrom: isFrom, to: &to) }
}

// TODO: - Extend
private func animate(from source: (layer: CALayer, bounds: CGRect), to destination: (layer: CALayer, bounds: CGRect), in overlayView: UIView, animationDuration: TimeInterval) {
    let from = source.layer
    let to = destination.layer
    if let fromLayerSnapshot = from.getSnapshot(shouldUnhide: true), let toLayerSnapshot = to.getSnapshot(shouldUnhide: true) {
        let transitionAnimation = to.transitionAnimation
        to.isHidden = true
        from.isHidden = true
        toLayerSnapshot.opacity = 0
        let fromConvertedFrame = source.bounds
        let toConvertedFrame = destination.bounds
        let fromConvertedPosition = source.bounds.position
        let toConvertedPosition = destination.bounds.position
        fromLayerSnapshot.frame.origin = fromConvertedFrame.origin
        toLayerSnapshot.frame.origin = toConvertedFrame.origin
        overlayView.layer.addSublayer(fromLayerSnapshot)
        overlayView.layer.addSublayer(toLayerSnapshot)
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            fromLayerSnapshot.removeFromSuperlayer()
            from.isHidden = false
            to.isHidden = false
            toLayerSnapshot.removeFromSuperlayer()
        }

        func addAnimations(to layer: CALayer, corner: CGFloat, isTarget: Bool, transitionAnimation: VATransitionAnimation) {
            switch transitionAnimation {
            case let .default(timings, additions):
                layer.add(animation: .bounds(from: fromLayerSnapshot.bounds, to: toLayerSnapshot.bounds), duration: animationDuration, timingFunction: timings.bounds, removeOnCompletion: false)
                layer.add(animation: .positionX(from: fromConvertedPosition.x, to: toConvertedPosition.x), duration: animationDuration, timingFunction: timings.positionX, removeOnCompletion: false)
                layer.add(animation: .positionY(from: fromConvertedPosition.y, to: toConvertedPosition.y), duration: animationDuration, timingFunction: timings.positionY, removeOnCompletion: false)
                layer.add(animation: .cornerRadius(from: layer.cornerRadius, to: corner), duration: animationDuration, timingFunction: timings.cornerRadius, removeOnCompletion: false)
                let shouldAnimateOpacity: Bool
                switch additions.opacity {
                case .skip: shouldAnimateOpacity = false
                case .skipSource: shouldAnimateOpacity = !isTarget
                case .skipDestination: shouldAnimateOpacity = isTarget
                default: shouldAnimateOpacity = true
                }
                if shouldAnimateOpacity {
                    layer.add(animation: .opacity(from: isTarget ? 0 : 1, to: !isTarget ? 0 : 1), duration: animationDuration, timingFunction: timings.opacity, removeOnCompletion: false)
                }
            }
        }
        
        addAnimations(to: fromLayerSnapshot, corner: toLayerSnapshot.cornerRadius, isTarget: false, transitionAnimation: transitionAnimation)
        addAnimations(to: toLayerSnapshot, corner: fromLayerSnapshot.cornerRadius, isTarget: true, transitionAnimation: transitionAnimation)
        CATransaction.commit()
    }
}
