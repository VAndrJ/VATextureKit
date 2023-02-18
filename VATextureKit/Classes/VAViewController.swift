//
//  VAViewController.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

public extension VAViewController where Node: VASafeAreaThemeDisplayNode<Theme> {
    
    convenience init(themeManager: VAThemeManager<Theme>) {
        self.init(node: Node(themeManager: themeManager), themeManager: themeManager)
    }
}

public extension VAViewController where Node: VAThemeDisplayNode<Theme> {
    
    convenience init(themeManager: VAThemeManager<Theme>) {
        self.init(node: Node(themeManager: themeManager), themeManager: themeManager)
    }
}

open class VAViewController<Node: ASDisplayNode, Theme>: ASDKViewController<ASDisplayNode> {
    open override var preferredStatusBarStyle: UIStatusBarStyle { (themeManager.theme as! VATheme).statusBarStyle }
    public var contentNode: Node { node as! Node }
    public let themeManager: VAThemeManager<Theme>
    
    public init(node: Node, themeManager: VAThemeManager<Theme>) {
        self.themeManager = themeManager
        
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
            name: VAThemeManager<Any>.themeDidChangedNotification,
            object: nil
        )
    }
    
    open func configureTheme() {}
    
    @objc private func themeDidChanged(_ notification: Notification) {
        setNeedsStatusBarAppearanceUpdate()
        configureTheme()
    }
}
