//
//  VACornerRoundingParameters.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 24.08.2023.
//

public import AsyncDisplayKit

public final class VACornerRoundingParameters: Equatable, @unchecked Sendable {
    /// Representing different corner radius configurations for a UI component.
    public enum CornerRadius: Equatable {
        /// A fixed corner radius
        ///
        /// Example usage:
        /// ```swift
        /// radius: .fixed(10.0)
        /// ```
        /// Creates a fixed corner radius of 10.0, same to `cornerRadius = 10.0`
        case fixed(_ radius: CGFloat)
        /// A proportional corner radius relative to the size of the component.
        ///
        /// Example usage:
        /// ```swift
        /// radius: .proportional(100.0)
        /// ```
        /// Creates a proportional corner radius half of the component's size, same to `min(bounds.width, bounds.height) / 2`.
        /// Updates when element resized.
        case proportional(percent: CGFloat)
    }

    public static func == (lhs: VACornerRoundingParameters, rhs: VACornerRoundingParameters) -> Bool {
        lhs.radius == rhs.radius &&
        lhs.curve == rhs.curve &&
        lhs.roundingType == rhs.roundingType &&
        lhs.maskedCorners == rhs.maskedCorners &&
        lhs.clipsToBounds == rhs.clipsToBounds
    }

    public static let `default`: VACornerRoundingParameters = .init()

    public let radius: CornerRadius
    public let curve: VACornerCurve
    public let roundingType: ASCornerRoundingType
    public let maskedCorners: CACornerMask
    public let clipsToBounds: Bool

    public init(
        radius: VACornerRoundingParameters.CornerRadius = .fixed(0),
        curve: VACornerCurve = .continuous,
        roundingType: ASCornerRoundingType = .defaultSlowCALayer,
        maskedCorners: CACornerMask = [
            .layerMaxXMaxYCorner,
            .layerMaxXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMinXMinYCorner,
        ],
        clipsToBounds: Bool = false
    ) {
        self.radius = radius
        self.curve = curve
        self.roundingType = roundingType
        self.maskedCorners = maskedCorners
        self.clipsToBounds = clipsToBounds
    }
}

public protocol VACornerable {
    var corner: VACornerRoundingParameters { get }
}

public extension VACornerable where Self: ASDisplayNode {

    func updateCornerProportionalIfNeeded() {
        if case let .proportional(percent) = corner.radius {
            cornerRadius = min(bounds.width, bounds.height) * percent / 200
        }
    }
    
    func updateCornerParameters() {
        clipsToBounds = corner.clipsToBounds
        maskedCorners = corner.maskedCorners
        cornerCurve = corner.curve
        cornerRoundingType = corner.roundingType
        if case let .fixed(value) = corner.radius {
            cornerRadius = value
        } else {
            setNeedsLayout()
        }
    }
}
