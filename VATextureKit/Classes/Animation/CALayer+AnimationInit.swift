//
//  CALayer+AnimationInit.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 29.07.2023.
//

import Foundation

public extension CALayer.VALayerAnimation {

    init(from: VALayerAnimationValueConvertible?, to: VALayerAnimationValueConvertible?, keyPath: String, isToEqualsFrom: Bool) {
        self.init(
            from: from?.animationValue,
            to: to?.animationValue,
            fromOriginalValue: from,
            toOriginalValue: to,
            keyPath: keyPath,
            isToEqualsFrom: isToEqualsFrom
        )
    }

    static func anchorPoint(from: CGPoint, to: CGPoint) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "anchorPoint",
            isToEqualsFrom: from == to
        )
    }

    static func backgroundColor(from: UIColor?, to: UIColor?) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "backgroundColor",
            isToEqualsFrom: from == to
        )
    }

    static func borderColor(from: UIColor?, to: UIColor?) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "borderColor",
            isToEqualsFrom: from == to
        )
    }

    static func borderWidth(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "borderWidth",
            isToEqualsFrom: from == to
        )
    }

    static func cornerRadius(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "cornerRadius",
            isToEqualsFrom: from == to
        )
    }

    static func opacity(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "opacity",
            isToEqualsFrom: from == to
        )
    }

    static func scale(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "transform.scale",
            isToEqualsFrom: from == to
        )
    }

    static func scaleX(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "transform.scale.x",
            isToEqualsFrom: from == to
        )
    }

    static func scaleY(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "transform.scale.y",
            isToEqualsFrom: from == to
        )
    }

    static func shadowColor(from: UIColor?, to: UIColor?) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "shadowColor",
            isToEqualsFrom: from == to
        )
    }

    static func shadowOpacity(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "shadowOpacity",
            isToEqualsFrom: from == to
        )
    }

    static func shadowOffset(from: CGSize, to: CGSize) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "shadowOffset",
            isToEqualsFrom: from == to
        )
    }

    static func shadowRadius(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "shadowRadius",
            isToEqualsFrom: from == to
        )
    }

    static func position(from: CGPoint, to: CGPoint) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "position",
            isToEqualsFrom: from == to
        )
    }

    static func positionX(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "position.x",
            isToEqualsFrom: from == to
        )
    }

    static func positionY(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "position.y",
            isToEqualsFrom: from == to
        )
    }

    static func bounds(from: CGRect, to: CGRect) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "bounds",
            isToEqualsFrom: from == to
        )
    }

    static func originX(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "bounds.origin.x",
            isToEqualsFrom: from == to
        )
    }

    static func originY(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "bounds.origin.y",
            isToEqualsFrom: from == to
        )
    }

    static func width(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "bounds.size.width",
            isToEqualsFrom: from == to
        )
    }

    static func height(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "bounds.size.height",
            isToEqualsFrom: from == to
        )
    }

    static func rotation(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "transform.rotation.z",
            isToEqualsFrom: from == to
        )
    }

    static func zPosition(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "zPosition",
            isToEqualsFrom: from == to
        )
    }

    static func rasterizationScale(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "rasterizationScale",
            isToEqualsFrom: from == to
        )
    }

    static func shadowPath(from: UIBezierPath?, to: UIBezierPath?) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "shadowPath",
            isToEqualsFrom: from == to
        )
    }
}

public extension CAGradientLayer.VALayerAnimation {

    static func locations(from: [CGFloat]?, to: [CGFloat]?) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "locations",
            isToEqualsFrom: from == to
        )
    }

    static func colors(from: [UIColor]?, to: [UIColor]?) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "colors",
            isToEqualsFrom: from == to
        )
    }

    static func startPoint(from: CGPoint, to: CGPoint) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "startPoint",
            isToEqualsFrom: from == to
        )
    }

    static func endPoint(from: CGPoint, to: CGPoint) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "endPoint",
            isToEqualsFrom: from == to
        )
    }
}

public extension CAShapeLayer.VALayerAnimation {

    static func lineDashPhase(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "lineDashPhase",
            isToEqualsFrom: from == to
        )
    }

    static func miterLimit(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "miterLimit",
            isToEqualsFrom: from == to
        )
    }

    static func lineWidth(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "lineWidth",
            isToEqualsFrom: from == to
        )
    }

    static func strokeStart(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "strokeStart",
            isToEqualsFrom: from == to
        )
    }

    static func strokeEnd(from: CGFloat, to: CGFloat) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "strokeEnd",
            isToEqualsFrom: from == to
        )
    }

    static func strokeColor(from: UIColor?, to: UIColor?) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "strokeColor",
            isToEqualsFrom: from == to
        )
    }

    static func fillColor(from: UIColor?, to: UIColor?) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "fillColor",
            isToEqualsFrom: from == to
        )
    }

    static func path(from: UIBezierPath?, to: UIBezierPath?) -> Self {
        .init(
            from: from,
            to: to,
            keyPath: "path",
            isToEqualsFrom: from == to
        )
    }
}

public extension CALayer.VALayerKeyframeAnimation {

    static func scale(values: [CGFloat]) -> Self {
        .init(values: values, keyPath: "transform.scale")
    }

    static func positionX(values: [CGFloat]) -> Self {
        .init(values: values, keyPath: "position.x")
    }

    static func positionY(values: [CGFloat]) -> Self {
        .init(values: values, keyPath: "position.y")
    }

    static func opacity(values: [CGFloat]) -> Self {
        .init(values: values, keyPath: "opacity")
    }

    static func anchorPoint(values: [CGPoint]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "anchorPoint")
    }

    static func backgroundColor(values: [UIColor]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "backgroundColor")
    }

    static func borderColor(values: [UIColor]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "borderColor")
    }

    static func borderWidth(values: [CGFloat]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "borderWidth")
    }

    static func cornerRadius(values: [CGFloat]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "cornerRadius")
    }

    static func scaleX(values: [CGFloat]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "transform.scale.x")
    }

    static func scaleY(values: [CGFloat]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "transform.scale.y")
    }

    static func shadowColor(values: [UIColor]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "shadowColor")
    }

    static func shadowOpacity(values: [CGFloat]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "shadowOpacity")
    }

    static func shadowOffset(values: [CGSize]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "shadowOffset")
    }

    static func shadowRadius(values: [CGFloat]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "shadowRadius")
    }

    static func position(values: [CGPoint]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "position")
    }

    static func bounds(values: [CGRect]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "bounds")
    }

    static func originX(values: [CGFloat]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "bounds.origin.x")
    }

    static func originY(values: [CGFloat]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "bounds.origin.y")
    }

    static func width(values: [CGFloat]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "bounds.size.width")
    }

    static func height(values: [CGFloat]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "bounds.size.height")
    }

    static func rotation(values: [CGFloat]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "transform.rotation.z")
    }

    static func zPosition(values: [CGFloat]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "zPosition")
    }

    static func rasterizationScale(values: [CGFloat]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "rasterizationScale")
    }

    static func shadowPath(values: [UIBezierPath]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "shadowPath")
    }
}

public extension CAGradientLayer.VALayerKeyframeAnimation {

    static func locations(values: [[CGFloat]]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "locations")
    }

    static func colors(values: [[UIColor]]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "colors")
    }

    static func startPoint(values: [CGPoint]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "startPoint")
    }

    static func endPoint(values: [CGPoint]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "endPoint")
    }
}

public extension CAShapeLayer.VALayerKeyframeAnimation {
    
    static func lineDashPhase(values: [CGFloat]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "lineDashPhase")
    }
    
    static func miterLimit(values: [CGFloat]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "miterLimit")
    }
    
    static func lineWidth(values: [CGFloat]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "lineWidth")
    }
    
    static func strokeStart(values: [CGFloat]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "strokeStart")
    }
    
    static func strokeEnd(values: [CGFloat]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "strokeEnd")
    }
    
    static func strokeColor(values: [UIColor]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "strokeColor")
    }
    
    static func fillColor(values: [UIColor]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "fillColor")
    }
    
    static func path(values: [UIBezierPath]) -> Self {
        .init(values: values.map(\.animationValue), keyPath: "path")
    }
}
