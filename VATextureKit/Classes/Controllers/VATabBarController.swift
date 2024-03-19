//
//  VATabBarController.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VATabBarController: ASTabBarController, VAThemeObserver, VAContentSizeObserver {
    open override var childForStatusBarStyle: UIViewController? { selectedViewController }
    open override var childForStatusBarHidden: UIViewController? { selectedViewController }

    /// The currently active theme obtained from the app's context.
    public var theme: VATheme { appContext.themeManager.theme }

    private(set) var isObservingContentSizeChanges = false

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
        tabBar.barStyle = theme.barStyle
    }

    public func themeDidChanged(to newValue: VATheme) {
        configureTheme(newValue)
    }

    @objc open func configureContentSize(_ contentSize: UIContentSizeCategory) {}

    public func contentSizeDidChanged(to newValue: UIContentSizeCategory) {
        configureContentSize(newValue)
    }

    deinit {
        appContext.themeManager.removeThemeObserver(self)
        if isObservingContentSizeChanges {
            appContext.contentSizeManager.removeContentSizeObserver(self)
        }
    }
}
