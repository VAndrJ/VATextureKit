//
//  VAViewController.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

open class VAViewController<Node: ASDisplayNode>: ASDKViewController<ASDisplayNode>, UIAdaptivePresentationControllerDelegate, VAThemeObserver, VAContentSizeObserver {
    open override var preferredStatusBarStyle: UIStatusBarStyle { theme.statusBarStyle }
    
    public var contentNode: Node { node as! Node }
    /// The currently active theme obtained from the app's context.
    @inline(__always) @inlinable public var theme: VATheme { appContext.themeManager.theme }
    public lazy var transitionAnimator: any VATransionAnimator = VADefaultTransionAnimator(controller: self)

    nonisolated(unsafe) private(set) var isObservingContentSizeChanges = false

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

        configureTheme(theme)
        appContext.themeManager.addThemeObserver(self)
        if overrides(#selector(configureContentSize(_:))) {
            appContext.contentSizeManager.addContentSizeObserver(self)
            isObservingContentSizeChanges = true
        }
    }

    @objc open func configureTheme(_ theme: VATheme) {
        overrideUserInterfaceStyle = theme.userInterfaceStyle.uiUserInterfaceStyle
        setNeedsStatusBarAppearanceUpdate()
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

    open func presentationController(
        _ presentationController: UIPresentationController,
        willPresentWithAdaptiveStyle style: UIModalPresentationStyle,
        transitionCoordinator: (any UIViewControllerTransitionCoordinator)?
    ) {}

    open func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {}

    open func presentationController(
        _ presentationController: UIPresentationController,
        prepare adaptivePresentationController: UIPresentationController
    ) {}

    open func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {}

    deinit {
        appContext.themeManager.removeThemeObserver(self)
        if isObservingContentSizeChanges {
            appContext.contentSizeManager.removeContentSizeObserver(self)
        }
    }
}
