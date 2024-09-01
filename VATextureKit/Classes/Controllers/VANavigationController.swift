//
//  VANavigationController.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

open class VANavigationController: ASDKNavigationController, VAThemeObserver, VAContentSizeObserver {
    open override var childForStatusBarStyle: UIViewController? { topViewController }
    open override var childForStatusBarHidden: UIViewController? { topViewController }

    /// The currently active theme obtained from the app's context.
    @inline(__always) @inlinable public var theme: VATheme { appContext.themeManager.theme }
    public lazy var transitionAnimator: any VATransionAnimator = VADefaultTransionAnimator(controller: self)

    nonisolated(unsafe) private(set) var isObservingContentSizeChanges = false

    public override init(
        nibName nibNameOrNil: String?,
        bundle nibBundleOrNil: Bundle?
    ) {
        super.init(
            nibName: nibNameOrNil,
            bundle: nibBundleOrNil
        )
    }

    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        configureTheme(theme)
        appContext.themeManager.addThemeObserver(self)
        if overrides(#selector(configureContentSize(_:))) {
            appContext.contentSizeManager.addContentSizeObserver(self)
            isObservingContentSizeChanges = true
        }
    }

    @objc open func configureTheme(_ theme: VATheme) {
        navigationBar.barStyle = theme.barStyle
    }

    nonisolated public func themeDidChanged(to newValue: VATheme) {
        Task { @MainActor in
            configureTheme(newValue)
        }
    }

    @objc open func configureContentSize(_ contentSize: UIContentSizeCategory) {}

    nonisolated public func contentSizeDidChanged(to newValue: UIContentSizeCategory) {
        Task { @MainActor in
            configureContentSize(newValue)
        }
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

    deinit {
        appContext.themeManager.removeThemeObserver(self)
        if isObservingContentSizeChanges {
            appContext.contentSizeManager.removeContentSizeObserver(self)
        }
    }
}
