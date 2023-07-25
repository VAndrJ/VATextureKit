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
        // TODO: - Split for different animations
        if viewController.isTransitionAnimationEnabled,
           let destinationController = viewController as? ASDKViewController,
           let sourceController = viewControllers.last as? ASDKViewController {
            let transitionOverlayView = addTransitionOverlayView()
            var fromLayersDict: [String: (CALayer, CGRect)] = [:]
            storeAnimationLayers(layer: sourceController.node.layer, to: &fromLayersDict)
            if !fromLayersDict.isEmpty {
                destinationController.node.loadForPreview()
                mainAsync { [self] in
                    var toLayersDict: [String: (CALayer, CGRect)] = [:]
                    storeAnimationLayers(layer: destinationController.node.layer, to: &toLayersDict)
                    func getAnimations(from source: (layer: CALayer, bounds: CGRect), to destination: (layer: CALayer, bounds: CGRect), in overlayView: UIView) {
                        let from = source.layer
                        let to = destination.layer
                        if let fromLayerSnapshot = from.getSnapshot(), let toLayerSnapshot = to.getSnapshot() {
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
                    if !(fromLayersDict.isEmpty || toLayersDict.isEmpty) {
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
                    } else {
                        transitionOverlayView.removeFromSuperview()
                    }
                }
            } else {
                transitionOverlayView.removeFromSuperview()
            }
        }
        super.pushViewController(viewController, animated: animated)
    }

    private func storeAnimationLayers(layer: CALayer, to: inout [String: (CALayer, CGRect)]) {
        if let id = layer.transitionAnimationId {
            if let node = (layer.delegate as? _ASDisplayView)?.asyncdisplaykit_node {
                if node.isVisible {
                    to[id] = (layer, layer.convert(layer.bounds, to: view.layer))
                }
            } else {
                to[id] = (layer, layer.convert(layer.bounds, to: view.layer))
            }
        }
        layer.sublayers?.forEach { storeAnimationLayers(layer: $0, to: &to) }
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
