//
//  AppearanceColor.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 10.04.2024.
//

import UIKit

/// A property wrapper arround pure `UIColor`s to support different `userInterfaceStyle`.
@propertyWrapper
public struct AppearanceColor {
    public var wrappedValue: UIColor {
        UIColor {
            switch $0.userInterfaceStyle {
            case .dark: dark
            default: light
            }
        }
    }

    let light: UIColor
    let dark: UIColor

    public init(light: UIColor, dark: UIColor) {
        self.light = light
        self.dark = dark
    }
}
