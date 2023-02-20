//
//  VAViewController.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VAViewController<Node: ASDisplayNode>: ASDKViewController<ASDisplayNode> {
    open override var preferredStatusBarStyle: UIStatusBarStyle { theme.statusBarStyle }
    public var contentNode: Node { node as! Node }
    
    public override convenience init() {
        self.init(node: Node())
    }
    
    public init(node: Node) {
        super.init(node: node)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTheme()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChanged(_:)),
            name: VAThemeManager.themeDidChangedNotification,
            object: appContext.themeManager
        )
    }
    
    open func configureTheme() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = theme.userInterfaceStyle
        }
    }
    
    @objc private func themeDidChanged(_ notification: Notification) {
        configureTheme()
        setNeedsStatusBarAppearanceUpdate()
    }
}
