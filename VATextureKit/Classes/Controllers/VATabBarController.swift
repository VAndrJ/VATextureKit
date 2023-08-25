//
//  VATabBarController.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VATabBarController: ASTabBarController {
    open override var childForStatusBarStyle: UIViewController? { selectedViewController }
    open override var childForStatusBarHidden: UIViewController? { selectedViewController }

    /// The currently active theme obtained from the app's context.
    public var theme: VATheme { appContext.themeManager.theme }

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
        tabBar.barStyle = theme.barStyle
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
}
