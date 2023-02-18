//
//  VAWindow.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import UIKit

open class VAWindow<Theme>: UIWindow {
    public var themeManager: VAThemeManager<Theme>? {
        didSet { themeManager?.updateStandardThemeIfNeeded(userInterfaceStyle: traitCollection.userInterfaceStyle) }
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            themeManager?.updateStandardThemeIfNeeded(userInterfaceStyle: traitCollection.userInterfaceStyle)
        }
    }
}
