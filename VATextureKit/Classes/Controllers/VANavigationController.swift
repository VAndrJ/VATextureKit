//
//  VANavigationController.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VANavigationController: ASDKNavigationController {
    open override var childForStatusBarStyle: UIViewController? { topViewController }
    open override var childForStatusBarHidden: UIViewController? { topViewController }

    // TODO: - Animations configuration
    public var animationDuration = 0.5

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTheme(appContext.themeManager.theme)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChanged(_:)),
            name: VAThemeManager.themeDidChangedNotification,
            object: appContext.themeManager
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentSizeDidChanged(_:)),
            name: VAContentSizeManager.contentSizeDidChangedNotification,
            object: appContext.contentSizeManager
        )
    }

    open override func popViewController(animated: Bool) -> UIViewController? {
        guard let popController = super.popViewController(animated: animated) else {
            return nil
        }
        guard popController.isTransitionAnimationEnabled, popController != viewControllers.last,
              let destinationController = viewControllers.last as? ASDKViewController,
              let sourceController = popController as? ASDKViewController else {
            return popController
        }
        var fromLayersDict: [String: (CALayer, CGRect)] = [:]
        storeAnimationLayers(layer: sourceController.node.layer, isFrom: true, to: &fromLayersDict)
        guard !fromLayersDict.isEmpty else {
            return popController
        }
        var toLayersDict: [String: (CALayer, CGRect)] = [:]
        storeAnimationLayers(layer: destinationController.node.layer, isFrom: false, to: &toLayersDict)
        animateLayers(fromLayersDict: fromLayersDict, toLayersDict: toLayersDict, transitionOverlayView: addTransitionOverlayView())
        return popController
    }

    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard viewController.isTransitionAnimationEnabled,
              let destinationController = viewController as? ASDKViewController,
              let sourceController = viewControllers.last as? ASDKViewController else {
            super.pushViewController(viewController, animated: animated)
            return
        }
        var fromLayersDict: [String: (CALayer, CGRect)] = [:]
        storeAnimationLayers(layer: sourceController.node.layer, isFrom: true, to: &fromLayersDict)
        guard !fromLayersDict.isEmpty else {
            super.pushViewController(viewController, animated: animated)
            return
        }
        destinationController.node.loadForPreview()
        destinationController.node.layer.isHidden = true
        // MARK: - Crutch to get proper target layout on push
        mainAsync(after: 1 / 120) { [self] in
            var toLayersDict: [String: (CALayer, CGRect)] = [:]
            storeAnimationLayers(layer: destinationController.node.layer, isFrom: false, to: &toLayersDict)
            animateLayers(fromLayersDict: fromLayersDict, toLayersDict: toLayersDict, transitionOverlayView: addTransitionOverlayView())
            destinationController.node.layer.isHidden = false
        }
        super.pushViewController(viewController, animated: animated)
    }

    private func animateLayers(fromLayersDict: [String: (CALayer, CGRect)], toLayersDict: [String: (CALayer, CGRect)], transitionOverlayView: UIView) {
        if !(fromLayersDict.isEmpty || toLayersDict.isEmpty) {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                transitionOverlayView.removeFromSuperview()
            }
            for key in fromLayersDict.keys {
                if let from = fromLayersDict[key], let to = toLayersDict[key] {
                    animate(from: from, to: to, in: transitionOverlayView)
                }
            }
            CATransaction.commit()
        } else {
            transitionOverlayView.removeFromSuperview()
        }
    }

    // TODO: - Extend
    private func animate(from source: (layer: CALayer, bounds: CGRect), to destination: (layer: CALayer, bounds: CGRect), in overlayView: UIView) {
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

    private func addTransitionOverlayView() -> UIView {
        let transitionOverlayView = VATouchesPassThroughView()
        view.addSubview(transitionOverlayView)
        transitionOverlayView.frame = view.frame
        return transitionOverlayView
    }
    
    open func configureTheme(_ theme: VATheme) {
        navigationBar.barStyle = theme.barStyle
    }
    
    open func configureContentSize(_ contenSize: UIContentSizeCategory) {}
    
    @objc private func themeDidChanged(_ notification: Notification) {
        configureTheme(appContext.themeManager.theme)
    }
    
    @objc private func contentSizeDidChanged(_ notification: Notification) {
        configureContentSize(appContext.contentSizeManager.contentSize)
    }
}

private class VATouchesPassThroughView: UIView {

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
}
