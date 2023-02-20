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
    public private(set) weak var window: UIWindow?
    public private(set) var themeManager: VAThemeManager
    
    public init(themeManager: VAThemeManager, window: UIWindow) {
        self.window = window
        self.themeManager = themeManager
    }
}
