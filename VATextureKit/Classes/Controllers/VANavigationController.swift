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

    /// The currently active theme obtained from the app's context.
    public var theme: VATheme { appContext.themeManager.theme }
    public lazy var transitionAnimator: VATransionAnimator = VADefaultTransionAnimator(controller: self)

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    public override init(
        nibName nibNameOrNil: String?,
        bundle nibBundleOrNil: Bundle?
    ) {
        super.init(
            nibName: nibNameOrNil,
            bundle: nibBundleOrNil
        )
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
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
        navigationBar.barStyle = theme.barStyle
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

    open override func popViewController(animated: Bool) -> UIViewController? {
        guard let popController = super.popViewController(animated: animated) else {
            return nil
        }

        transitionAnimator.animateTransition(
            source: popController,
            destination: viewControllers.last,
            animated: animated,
            isPresenting: false
        )
        return popController
    }

    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        transitionAnimator.animateTransition(
            source: viewControllers.last,
            destination: viewController,
            animated: animated,
            isPresenting: true
        )
        
        super.pushViewController(viewController, animated: animated)
    }
}
