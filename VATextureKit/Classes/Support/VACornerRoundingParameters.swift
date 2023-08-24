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

    public init(
        radius: VACornerRoundingParameters.CornerRadius = .fixed(0),
        curve: VACornerCurve = .continuous,
        roundingType: ASCornerRoundingType = .defaultSlowCALayer
    ) {
        self.radius = radius
        self.curve = curve
        self.roundingType = roundingType
    }
}
