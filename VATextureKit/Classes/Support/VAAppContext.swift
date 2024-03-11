//
//  VAAppContext.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import UIKit

public var appContext: VAAppContext {
    if let appContext = appContexts.last {
        return appContext
    } else {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            let themeManager = VAThemeManager(standardLightTheme: .vaLight, standardDarkTheme: .vaDark)

            return VAAppContext(
                themeManager: themeManager,
                window: VAWindow(legacyLightTheme: .vaLight)
            )
        } else {
            fatalError("Use VAWindow instead of UIWindow")
        }
    }
}
// TODO: - Multiple windows support
internal var appContexts: [VAAppContext] = []

public class VAAppContext {
    public private(set) weak var window: UIWindow?
    public private(set) var themeManager: VAThemeManager
    public private(set) var contentSizeManager: VAContentSizeManager

    let id: UUID

    public init(themeManager: VAThemeManager, window: VAWindow) {
        self.id = UUID()
        self.window = window
        self.themeManager = themeManager
        self.contentSizeManager = VAContentSizeManager(contentSize: window.traitCollection.preferredContentSizeCategory)

        window.id = id
    }
}
