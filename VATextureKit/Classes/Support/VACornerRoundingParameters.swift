//
//  VACornerRoundingParameters.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 24.08.2023.
//

import AsyncDisplayKit

public struct VACornerRoundingParameters: Equatable {
    public enum CornerRadius: Equatable {
        case fixed(_ radius: CGFloat)
        case proportional(percent: CGFloat)
    }

    public let radius: CornerRadius
    public let curve: VACornerCurve
    public let roundingType: ASCornerRoundingType
    public let maskedCorners: CACornerMask

    public init(
        radius: VACornerRoundingParameters.CornerRadius = .fixed(0),
        curve: VACornerCurve = .continuous,
        roundingType: ASCornerRoundingType = .defaultSlowCALayer,
        maskedCorners: CACornerMask = [
            .layerMaxXMaxYCorner,
            .layerMaxXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMinXMinYCorner,
        ]
    ) {
        self.radius = radius
        self.curve = curve
        self.roundingType = roundingType
        self.maskedCorners = maskedCorners
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
