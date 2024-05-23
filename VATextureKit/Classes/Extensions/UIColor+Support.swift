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
    @inline(__always) @inlinable static func fromAlpha(
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

        return .init(red: red, green: green, blue: blue, alpha: 1)
    }

    /// Returns the components that make up the color in the RGBA color space as a tuple.
    ///
    /// - Returns: The RGBA components of the color or `nil` if the color could not be converted to RGBA color space.
    var rgbComponents: (red: CGFloat, green: CGFloat, blue: CGFloat)? {
        var (red, green, blue, alpha) = (CGFloat.zero, CGFloat.zero, CGFloat.zero, CGFloat.zero)
        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            var gray: CGFloat = 0
            if getWhite(&gray, alpha: &alpha) {
                return (gray, gray, gray)
            }

            return nil
        }

        return (red, green, blue)
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
    @inline(__always) @inlinable func opaque(on background: UIColor, traitCollection: UITraitCollection) -> UIColor {
        .fromAlpha(
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
    @inline(__always) @inlinable func opaque(on background: UIColor) -> UIColor {
        .fromAlpha(
            foreground: self,
            background: background
        )
    }
}

public extension [UIColor] {

    func getAveragePigments(on background: UIColor) -> UIColor {

        func map(
            components: (red: CGFloat, green: CGFloat, blue: CGFloat),
            parameter: CGFloat,
            transform: (CGFloat, CGFloat) -> CGFloat
        ) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
            (transform(components.red, parameter), transform(components.green, parameter), transform(components.blue, parameter))
        }

        var whiteComponents: [CGFloat] = []
        var colorComponents: [(red: CGFloat, green: CGFloat, blue: CGFloat)] = []
        self.map { $0.opaque(on: background) }.compactMap(\.rgbComponents).forEach { components in
            let white = Swift.min(Swift.min(components.red, components.green), components.blue)
            whiteComponents.append(white)
            colorComponents.append(map(components: components, parameter: white, transform: -))
        }
        let averageWhite = whiteComponents.reduce(0, +) / CGFloat(whiteComponents.count)
        var averageColor = colorComponents.reduce((red: 0.0, green: 0.0, blue: 0.0), {
            ($0.red + $1.red, $0.green + $1.green, $0.blue + $1.blue)
        })
        let white = Swift.min(Swift.min(averageColor.red, averageColor.green), averageColor.blue)
        averageColor = map(components: averageColor, parameter: white, transform: -)
        averageColor.green += white
        averageColor = map(components: averageColor, parameter: averageWhite, transform: +)

        return .init(
            red: Swift.min(1, averageColor.red),
            green: Swift.min(1, averageColor.green),
            blue: Swift.min(1, averageColor.blue),
            alpha: 1
        )
    }

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

        return .init(
            red: redSum / componentsCount,
            green: greenSum / componentsCount,
            blue: blueSum / componentsCount,
            alpha: alphaSum / componentsCount
        )
    }
}
