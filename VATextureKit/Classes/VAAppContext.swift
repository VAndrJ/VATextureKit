//
//  VAAppContext.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import UIKit

public var theme: VATheme { appContext.themeManager.theme }
public var appContext: VAAppContext { appContexts.last! }
// TODO: - Multiple windows support
internal var appContexts: [VAAppContext] = []

public class VAAppContext {
    public static let contentSizeDidChangedNotification = Notification.Name("VAThemeManager.themeDidChangedNotification")
    
    public private(set) weak var window: UIWindow?
    public private(set) var themeManager: VAThemeManager
    public private(set) var contentSize: UIContentSizeCategory
    
    public init(themeManager: VAThemeManager, window: UIWindow) {
        self.window = window
        self.themeManager = themeManager
        self.contentSize = window.traitCollection.preferredContentSizeCategory
    }
    
    public func update(contentSize: UIContentSizeCategory) {
        self.contentSize = contentSize
        NotificationCenter.default.post(name: Self.contentSizeDidChangedNotification, object: self)
    }
}
