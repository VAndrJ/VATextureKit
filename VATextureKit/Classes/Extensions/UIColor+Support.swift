//
//  UIColor+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 03.08.2023.
//

import UIKit

public extension UIColor {

    /// Creates a new `UIColor` by blending the foreground color with the background color based on the specified alpha value, resolved with the specified `UITraitCollection`.
    ///
    /// - Parameters:
    ///   - foreground: The foreground `UIColor` that will be blended with the background color.
    ///   - background: The background `UIColor` to be used as the base color for blending. Defaults to `white`
    ///   - traitCollection: `UITraitCollection` to resolve color.
    /// - Returns: A new `UIColor` that is the result of blending the foreground color with the background color using the specified alpha value.
    @available (iOS 13.0, *)
    static func fromAlpha(
        foreground: UIColor,
        background: UIColor = .white,
        traitCollection: UITraitCollection
    ) -> UIColor {
        fromAlpha(
            foreground: foreground.resolvedColor(with: traitCollection),
            background: background.resolvedColor(with: traitCollection)
        )
    }

    /// Creates a new `UIColor` by blending the foreground color with the background color based on the specified alpha value.
    ///
    /// - Parameters:
    ///   - foreground: The foreground `UIColor` that will be blended with the background color.
    ///   - background: The background `UIColor` to be used as the base color for blending. Defaults to `white`
    /// - Returns: A new `UIColor` that is the result of blending the foreground color with the background color using the specified alpha value.
    static func fromAlpha(foreground: UIColor, background: UIColor = .white) -> UIColor {
        guard let foregroundComponents = foreground.rgbaComponents,
              let backgroundComponents = background.rgbaComponents else {
            return foreground
        }

        func computeComponent(alpha: CGFloat, foreground: CGFloat, background: CGFloat) -> CGFloat {
            (1 - alpha) * background + alpha * foreground
        }

        let red = computeComponent(
            alpha: foregroundComponents.alpha,
            foreground: foregroundComponents.red,
            background: backgroundComponents.red
        )
        let green = computeComponent(
            alpha: foregroundComponents.alpha,
            foreground: foregroundComponents.green,
            background: backgroundComponents.green
        )
        let blue = computeComponent(
            alpha: foregroundComponents.alpha,
            foreground: foregroundComponents.blue,
            background: backgroundComponents.blue
        )

        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }

    /// Returns the components that make up the color in the RGBA color space as a tuple.
    ///
    /// - Returns: The RGBA components of the color or `nil` if the color could not be converted to RGBA color space.
    var rgbaComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var (red, green, blue, alpha) = (CGFloat.zero, CGFloat.zero, CGFloat.zero, CGFloat.zero)
        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            var gray: CGFloat = 0
            if getWhite(&gray, alpha: &alpha) {
                return (gray, gray, gray, alpha)
            }

            return nil
        }

        return (red, green, blue, alpha)
    }

    /// Creates a new `UIColor` by blending the current color with the background color based on the specified alpha value, resolved with the specified `UITraitCollection`.
    ///
    /// - Parameters:
    ///   - background: The background `UIColor` to be used as the base color for blending.
    ///   - traitCollection: `UITraitCollection` to resolve color.
    /// - Returns: A new `UIColor` that is the result of blending the foreground color with the background color using the specified alpha value.
    @available (iOS 13.0, *)
    func opaque(on background: UIColor, traitCollection: UITraitCollection) -> UIColor {
        UIColor.fromAlpha(
            foreground: self,
            background: background,
            traitCollection: traitCollection
        )
    }

    /// Creates a new `UIColor` by blending the current color with the background color based on the specified alpha value, resolved with the specified `UITraitCollection`.
    ///
    /// - Parameters:
    ///   - background: The background `UIColor` to be used as the base color for blending.
    /// - Returns: A new `UIColor` that is the result of blending the foreground color with the background color using the specified alpha value.
    func opaque(on background: UIColor) -> UIColor {
        UIColor.fromAlpha(
            foreground: self,
            background: background
        )
    }
}

public extension [UIColor] {

    var average: UIColor {
        var redSum = 0.0
        var greenSum = 0.0
        var blueSum = 0.0
        var alphaSum = 0.0
        let components = compactMap(\.rgbaComponents)
        for component in components {
            redSum += component.red
            greenSum += component.green
            blueSum += component.blue
            alphaSum += component.alpha
        }
        let componentsCount = CGFloat(components.count)

        return UIColor(
            red: redSum / componentsCount,
            green: greenSum / componentsCount,
            blue: blueSum / componentsCount,
            alpha: alphaSum / componentsCount
        )
    }
}
