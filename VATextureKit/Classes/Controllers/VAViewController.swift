//
//  VAViewController.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VAViewController<Node: ASDisplayNode>: ASDKViewController<ASDisplayNode> {
    open override var preferredStatusBarStyle: UIStatusBarStyle { appContext.themeManager.theme.statusBarStyle }
    
    public var contentNode: Node { node as! Node }
    public var theme: VATheme { appContext.themeManager.theme }
    
    public init(node: Node) {
        super.init(node: node)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
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
    }
    
    open func configureTheme(_ theme: VATheme) {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = theme.userInterfaceStyle.uiUserInterfaceStyle
        }
    }
    
    @objc private func themeDidChanged(_ notification: Notification) {
        configureTheme(appContext.themeManager.theme)
        setNeedsStatusBarAppearanceUpdate()
    }
}
