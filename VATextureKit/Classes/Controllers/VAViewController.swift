//
//  VAViewController.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VAViewController<Node: ASDisplayNode>: ASDKViewController<ASDisplayNode>, UIAdaptivePresentationControllerDelegate {
    open override var preferredStatusBarStyle: UIStatusBarStyle { theme.statusBarStyle }
    
    public var contentNode: Node { node as! Node }
    /// The currently active theme obtained from the app's context.
    public var theme: VATheme { appContext.themeManager.theme }
    public lazy var transitionAnimator: VATransionAnimator = VADefaultTransionAnimator(controller: self)
    
    public init(node: Node) {
        super.init(node: node)

        presentationController?.delegate = self
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        themeDidChanged()
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

    open func configureTheme(_ theme: VATheme) {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = theme.userInterfaceStyle.uiUserInterfaceStyle
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    open func themeDidChanged() {
        configureTheme(theme)
    }

    @objc private func themeDidChanged(_ notification: Notification) {
        themeDidChanged()
    }

    open func configureContentSize(_ contentSize: UIContentSizeCategory) {}

    open func contentSizeDidChanged() {
        configureContentSize(appContext.contentSizeManager.contentSize)
    }

    @objc private func contentSizeDidChanged(_ notification: Notification) {
        contentSizeDidChanged()
    }

    open override func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        transitionAnimator.animateTransition(
            source: self,
            destination: viewControllerToPresent,
            animated: flag,
            isPresenting: true
        )

        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)

        transitionAnimator.animateTransition(
            source: self,
            destination: presentingViewController,
            animated: flag,
            isPresenting: false
        )
    }

    // MARK: - UIAdaptivePresentationControllerDelegate

    open func presentationController(
        _ controller: UIPresentationController,
        viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle
    ) -> UIViewController? {
        return nil
    }

    open func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return true
    }

    open func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {}

    open func presentationController(_ presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {}

    open func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {}

    open func presentationController(_ presentationController: UIPresentationController, prepare adaptivePresentationController: UIPresentationController) {}

    open func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {}
}
