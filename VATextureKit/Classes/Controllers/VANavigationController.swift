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

    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // TODO: - Extend
        if viewController.isTransitionAnimationEnabled,
           let nextController = viewController as? ASDKViewController,
           let previousController = viewControllers.last as? ASDKViewController {
            nextController.node.displaysAsynchronously = false
            nextController.node.setNeedsDisplay()
            nextController.node.recursivelyEnsureDisplaySynchronously(true)
            var fromLayersDict: [String: CALayer] = [:]
            var toLayersDict: [String: CALayer] = [:]
            func storeAnimationLayers(layer: CALayer, to: inout [String: CALayer]) {
                if let id = layer.transitionAnimationId {
                    to[id] = layer
                }
                layer.sublayers?.forEach { storeAnimationLayers(layer: $0, to: &to) }
            }
            storeAnimationLayers(layer: previousController.node.layer, to: &fromLayersDict)
            storeAnimationLayers(layer: nextController.node.layer, to: &toLayersDict)
            func getAnimations(from: CALayer, to: CALayer, in overlayView: UIView) {
                if let fromLayerSnapshot = from.getSnapshot(), let toLayerSnapshot = to.getSnapshot() {
                    to.isHidden = true
                    from.isHidden = true
                    toLayerSnapshot.opacity = 0
                    let fromConvertedBounds = from.convert(from.bounds.origin, to: overlayView.layer)
                    var toBounds = to.bounds.origin
                    // TODO: - Without hardcode
                    toBounds.y += view.safeAreaInsets.top
                    toBounds.y += navigationBar.frame.height
                    let toConvertedBounds = to.convert(toBounds, to: overlayView.layer)
                    let fromConvertedPosition = from.convert(from.position - from.frame.origin, to: overlayView.layer)
                    var toPosition = to.position
                    toPosition.y += view.safeAreaInsets.top
                    toPosition.y += navigationBar.frame.height
                    let toConvertedPosition = to.convert(toPosition - to.frame.origin, to: overlayView.layer)
                    fromLayerSnapshot.frame.origin = fromConvertedBounds
                    toLayerSnapshot.frame.origin = toConvertedBounds
                    overlayView.layer.addSublayer(fromLayerSnapshot)
                    overlayView.layer.addSublayer(toLayerSnapshot)
                    fromLayerSnapshot.add(animation: .bounds(from: fromLayerSnapshot.bounds, to: toLayerSnapshot.bounds), duration: animationDuration)
                    fromLayerSnapshot.add(animation: .position(from: fromConvertedPosition, to: toConvertedPosition), duration: animationDuration)
                    fromLayerSnapshot.add(animation: .opacity(from: 1, to: 0), duration: animationDuration)
                    toLayerSnapshot.add(animation: .bounds(from: fromLayerSnapshot.bounds, to: toLayerSnapshot.bounds), duration: animationDuration)
                    toLayerSnapshot.add(animation: .position(from: fromConvertedPosition, to: toConvertedPosition), duration: animationDuration)
                    toLayerSnapshot.add(animation: .opacity(from: 0, to: 1), duration: animationDuration, completion: { _ in
                        from.isHidden = false
                        to.isHidden = false
                        toLayerSnapshot.removeFromSuperlayer()
                        fromLayerSnapshot.removeFromSuperlayer()
                    })
                }
            }
            if !(fromLayersDict.isEmpty || toLayersDict.isEmpty) {
                let transitionOverlayView = addTransitionOverlayView()
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    transitionOverlayView.removeFromSuperview()
                }
                for key in fromLayersDict.keys {
                    if let from = fromLayersDict[key], let to = toLayersDict[key] {
                        getAnimations(from: from, to: to, in: transitionOverlayView)
                    }
                }
                CATransaction.commit()
            }
        }
        super.pushViewController(viewController, animated: animated)
    }

    // TODO: - Touches transparent
    private func addTransitionOverlayView() -> UIView {
        let transitionOverlayView = UIView()
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
