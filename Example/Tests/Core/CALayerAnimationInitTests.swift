//
//  CALayerAnimationInitTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 01.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class CALayerAnimationInitTests: XCTestCase {

    func test_layerAnimation_keyPath() {
        let animation = CALayer.VALayerAnimation(from: CGPoint.zero, to: CGPoint.zero, keyPath: "animation", isToEqualsFrom: true)
        XCTAssertEqual(CGPoint.zero, animation.fromOriginalValue as? CGPoint)
        XCTAssertEqual(CGPoint.zero, animation.toOriginalValue as? CGPoint)
        XCTAssertEqual(NSValue(cgPoint: .zero), animation.from as? NSValue)
        XCTAssertEqual(NSValue(cgPoint: .zero), animation.to as? NSValue)
        XCTAssertEqual("animation", animation.keyPath)
        XCTAssertEqual(true, animation.isToEqualsFrom)

        let anchorPoint = CALayer.VALayerAnimation.anchorPoint(from: .zero, to: .zero)
        XCTAssertEqual("anchorPoint", anchorPoint.keyPath)

        let backgroundColor = CALayer.VALayerAnimation.backgroundColor(from: nil, to: nil)
        XCTAssertEqual("backgroundColor", backgroundColor.keyPath)

        let borderColor = CALayer.VALayerAnimation.borderColor(from: nil, to: nil)
        XCTAssertEqual("borderColor", borderColor.keyPath)

        let borderWidth = CALayer.VALayerAnimation.borderWidth(from: 0, to: 0)
        XCTAssertEqual("borderWidth", borderWidth.keyPath)

        let cornerRadius = CALayer.VALayerAnimation.cornerRadius(from: 0, to: 0)
        XCTAssertEqual("cornerRadius", cornerRadius.keyPath)

        let opacity = CALayer.VALayerAnimation.opacity(from: 0, to: 0)
        XCTAssertEqual("opacity", opacity.keyPath)

        let scale = CALayer.VALayerAnimation.scale(from: 0, to: 0)
        XCTAssertEqual("transform.scale", scale.keyPath)

        let scaleX = CALayer.VALayerAnimation.scaleX(from: 0, to: 0)
        XCTAssertEqual("transform.scale.x", scaleX.keyPath)

        let scaleY = CALayer.VALayerAnimation.scaleY(from: 0, to: 0)
        XCTAssertEqual("transform.scale.y", scaleY.keyPath)

        let shadowColor = CALayer.VALayerAnimation.shadowColor(from: nil, to: nil)
        XCTAssertEqual("shadowColor", shadowColor.keyPath)

        let shadowOpacity = CALayer.VALayerAnimation.shadowOpacity(from: 0, to: 0)
        XCTAssertEqual("shadowOpacity", shadowOpacity.keyPath)

        let shadowOffset = CALayer.VALayerAnimation.shadowOffset(from: .zero, to: .zero)
        XCTAssertEqual("shadowOffset", shadowOffset.keyPath)

        let shadowRadius = CALayer.VALayerAnimation.shadowRadius(from: 0, to: 0)
        XCTAssertEqual("shadowRadius", shadowRadius.keyPath)

        let position = CALayer.VALayerAnimation.position(from: .zero, to: .zero)
        XCTAssertEqual("position", position.keyPath)

        let positionX = CALayer.VALayerAnimation.positionX(from: 0, to: 0)
        XCTAssertEqual("position.x", positionX.keyPath)

        let positionY = CALayer.VALayerAnimation.positionY(from: 0, to: 0)
        XCTAssertEqual("position.y", positionY.keyPath)

        let bounds = CALayer.VALayerAnimation.bounds(from: .zero, to: .zero)
        XCTAssertEqual("bounds", bounds.keyPath)

        let originX = CALayer.VALayerAnimation.originX(from: 0, to: 0)
        XCTAssertEqual("bounds.origin.x", originX.keyPath)

        let originY = CALayer.VALayerAnimation.originY(from: 0, to: 0)
        XCTAssertEqual("bounds.origin.y", originY.keyPath)

        let width = CALayer.VALayerAnimation.width(from: 0, to: 0)
        XCTAssertEqual("bounds.size.width", width.keyPath)

        let height = CALayer.VALayerAnimation.height(from: 0, to: 0)
        XCTAssertEqual("bounds.size.height", height.keyPath)

        let rotation = CALayer.VALayerAnimation.rotation(from: 0, to: 0)
        XCTAssertEqual("transform.rotation.z", rotation.keyPath)

        let zPosition = CALayer.VALayerAnimation.zPosition(from: 0, to: 0)
        XCTAssertEqual("zPosition", zPosition.keyPath)

        let rasterizationScale = CALayer.VALayerAnimation.rasterizationScale(from: 0, to: 0)
        XCTAssertEqual("rasterizationScale", rasterizationScale.keyPath)

        let shadowPath = CALayer.VALayerAnimation.shadowPath(from: nil, to: nil)
        XCTAssertEqual("shadowPath", shadowPath.keyPath)

        let locations = CALayer.VALayerAnimation.locations(from: nil, to: nil)
        XCTAssertEqual("locations", locations.keyPath)

        let colors = CALayer.VALayerAnimation.colors(from: nil, to: nil)
        XCTAssertEqual("colors", colors.keyPath)

        let startPoint = CALayer.VALayerAnimation.startPoint(from: .zero, to: .zero)
        XCTAssertEqual("startPoint", startPoint.keyPath)

        let endPoint = CALayer.VALayerAnimation.endPoint(from: .zero, to: .zero)
        XCTAssertEqual("endPoint", endPoint.keyPath)

        let lineDashPhase = CALayer.VALayerAnimation.lineDashPhase(from: 0, to: 0)
        XCTAssertEqual("lineDashPhase", lineDashPhase.keyPath)

        let miterLimit = CALayer.VALayerAnimation.miterLimit(from: 0, to: 0)
        XCTAssertEqual("miterLimit", miterLimit.keyPath)

        let lineWidth = CALayer.VALayerAnimation.lineWidth(from: 0, to: 0)
        XCTAssertEqual("lineWidth", lineWidth.keyPath)

        let strokeStart = CALayer.VALayerAnimation.strokeStart(from: 0, to: 0)
        XCTAssertEqual("strokeStart", strokeStart.keyPath)

        let strokeEnd = CALayer.VALayerAnimation.strokeEnd(from: 0, to: 0)
        XCTAssertEqual("strokeEnd", strokeEnd.keyPath)

        let strokeColor = CALayer.VALayerAnimation.strokeColor(from: nil, to: nil)
        XCTAssertEqual("strokeColor", strokeColor.keyPath)

        let fillColor = CALayer.VALayerAnimation.fillColor(from: nil, to: nil)
        XCTAssertEqual("fillColor", fillColor.keyPath)

        let path = CALayer.VALayerAnimation.path(from: nil, to: nil)
        XCTAssertEqual("path", path.keyPath)
    }

    func test_keyframeAnimation_keyPath() {
        let cgFloatArr: [CGFloat] = [0, 1]
        let pointArr: [CGPoint] = [.zero, .init(x: 1, y: 1)]
        let sizesArr: [CGSize] = [.zero, .init(width: 1, height: 1)]
        let rectsArr: [CGRect] = [.zero, CGRect(x: 1, y: 1, width: 1, height: 1)]
        let colorsArr: [UIColor] = [.clear, .white]
        let pathsArr: [UIBezierPath] = [UIBezierPath(), UIBezierPath()]

        let anchorPoint = CALayer.VALayerKeyframeAnimation.anchorPoint(values: pointArr)
        XCTAssertEqual(pointArr as [NSValue], anchorPoint.values as? [NSValue])
        XCTAssertEqual("anchorPoint", anchorPoint.keyPath)

        let backgroundColor = CALayer.VALayerKeyframeAnimation.backgroundColor(values: colorsArr)
        XCTAssertEqual(colorsArr.map(\.cgColor), backgroundColor.values as? [CGColor])
        XCTAssertEqual("backgroundColor", backgroundColor.keyPath)

        let borderColor = CALayer.VALayerKeyframeAnimation.borderColor(values: colorsArr)
        XCTAssertEqual(colorsArr.map(\.cgColor), borderColor.values as? [CGColor])
        XCTAssertEqual("borderColor", borderColor.keyPath)

        let borderWidth = CALayer.VALayerKeyframeAnimation.borderWidth(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], borderWidth.values as? [NSValue])
        XCTAssertEqual("borderWidth", borderWidth.keyPath)

        let cornerRadius = CALayer.VALayerKeyframeAnimation.cornerRadius(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], cornerRadius.values as? [NSValue])
        XCTAssertEqual("cornerRadius", cornerRadius.keyPath)

        let opacity = CALayer.VALayerKeyframeAnimation.opacity(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], opacity.values as? [NSValue])
        XCTAssertEqual("opacity", opacity.keyPath)

        let scale = CALayer.VALayerKeyframeAnimation.scale(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], scale.values as? [NSValue])
        XCTAssertEqual("transform.scale", scale.keyPath)

        let scaleX = CALayer.VALayerKeyframeAnimation.scaleX(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], scaleX.values as? [NSValue])
        XCTAssertEqual("transform.scale.x", scaleX.keyPath)

        let scaleY = CALayer.VALayerKeyframeAnimation.scaleY(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], scaleY.values as? [NSValue])
        XCTAssertEqual("transform.scale.y", scaleY.keyPath)

        let shadowColor = CALayer.VALayerKeyframeAnimation.shadowColor(values: colorsArr)
        XCTAssertEqual(colorsArr.map(\.cgColor), shadowColor.values as? [CGColor])
        XCTAssertEqual("shadowColor", shadowColor.keyPath)

        let shadowOpacity = CALayer.VALayerKeyframeAnimation.shadowOpacity(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], shadowOpacity.values as? [NSValue])
        XCTAssertEqual("shadowOpacity", shadowOpacity.keyPath)

        let shadowOffset = CALayer.VALayerKeyframeAnimation.shadowOffset(values: sizesArr)
        XCTAssertEqual(sizesArr as [NSValue], shadowOffset.values as? [NSValue])
        XCTAssertEqual("shadowOffset", shadowOffset.keyPath)

        let shadowRadius = CALayer.VALayerKeyframeAnimation.shadowRadius(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], shadowRadius.values as? [NSValue])
        XCTAssertEqual("shadowRadius", shadowRadius.keyPath)

        let position = CALayer.VALayerKeyframeAnimation.position(values: pointArr)
        XCTAssertEqual(pointArr as [NSValue], position.values as? [NSValue])
        XCTAssertEqual("position", position.keyPath)

        let positionX = CALayer.VALayerKeyframeAnimation.positionX(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], positionX.values as? [NSValue])
        XCTAssertEqual("position.x", positionX.keyPath)

        let positionY = CALayer.VALayerKeyframeAnimation.positionY(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], positionY.values as? [NSValue])
        XCTAssertEqual("position.y", positionY.keyPath)

        let bounds = CALayer.VALayerKeyframeAnimation.bounds(values: rectsArr)
        XCTAssertEqual(rectsArr as [NSValue], bounds.values as? [NSValue])
        XCTAssertEqual("bounds", bounds.keyPath)

        let originX = CALayer.VALayerKeyframeAnimation.originX(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], originX.values as? [NSValue])
        XCTAssertEqual("bounds.origin.x", originX.keyPath)

        let originY = CALayer.VALayerKeyframeAnimation.originY(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], originY.values as? [NSValue])
        XCTAssertEqual("bounds.origin.y", originY.keyPath)

        let width = CALayer.VALayerKeyframeAnimation.width(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], width.values as? [NSValue])
        XCTAssertEqual("bounds.size.width", width.keyPath)

        let height = CALayer.VALayerKeyframeAnimation.height(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], height.values as? [NSValue])
        XCTAssertEqual("bounds.size.height", height.keyPath)

        let rotation = CALayer.VALayerKeyframeAnimation.rotation(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], rotation.values as? [NSValue])
        XCTAssertEqual("transform.rotation.z", rotation.keyPath)

        let zPosition = CALayer.VALayerKeyframeAnimation.zPosition(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], zPosition.values as? [NSValue])
        XCTAssertEqual("zPosition", zPosition.keyPath)

        let rasterizationScale = CALayer.VALayerKeyframeAnimation.rasterizationScale(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], rasterizationScale.values as? [NSValue])
        XCTAssertEqual("rasterizationScale", rasterizationScale.keyPath)

        let shadowPath = CALayer.VALayerKeyframeAnimation.shadowPath(values: pathsArr)
        XCTAssertEqual(pathsArr.map(\.cgPath), shadowPath.values as? [CGPath])
        XCTAssertEqual("shadowPath", shadowPath.keyPath)

        let locations = CALayer.VALayerKeyframeAnimation.locations(values: [cgFloatArr])
        XCTAssertEqual([cgFloatArr as [NSValue]], locations.values as? [[NSValue]])
        XCTAssertEqual("locations", locations.keyPath)

        let colors = CALayer.VALayerKeyframeAnimation.colors(values: [colorsArr])
        XCTAssertEqual([colorsArr.map(\.cgColor)], colors.values as? [[CGColor]])
        XCTAssertEqual("colors", colors.keyPath)

        let startPoint = CALayer.VALayerKeyframeAnimation.startPoint(values: pointArr)
        XCTAssertEqual(pointArr as [NSValue], startPoint.values as? [NSValue])
        XCTAssertEqual("startPoint", startPoint.keyPath)

        let endPoint = CALayer.VALayerKeyframeAnimation.endPoint(values: pointArr)
        XCTAssertEqual(pointArr as [NSValue], endPoint.values as? [NSValue])
        XCTAssertEqual("endPoint", endPoint.keyPath)

        let lineDashPhase = CALayer.VALayerKeyframeAnimation.lineDashPhase(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], lineDashPhase.values as? [NSValue])
        XCTAssertEqual("lineDashPhase", lineDashPhase.keyPath)

        let miterLimit = CALayer.VALayerKeyframeAnimation.miterLimit(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], miterLimit.values as? [NSValue])
        XCTAssertEqual("miterLimit", miterLimit.keyPath)

        let lineWidth = CALayer.VALayerKeyframeAnimation.lineWidth(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], lineWidth.values as? [NSValue])
        XCTAssertEqual("lineWidth", lineWidth.keyPath)

        let strokeStart = CALayer.VALayerKeyframeAnimation.strokeStart(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], strokeStart.values as? [NSValue])
        XCTAssertEqual("strokeStart", strokeStart.keyPath)

        let strokeEnd = CALayer.VALayerKeyframeAnimation.strokeEnd(values: cgFloatArr)
        XCTAssertEqual(cgFloatArr as [NSValue], strokeEnd.values as? [NSValue])
        XCTAssertEqual("strokeEnd", strokeEnd.keyPath)

        let strokeColor = CALayer.VALayerKeyframeAnimation.strokeColor(values: colorsArr)
        XCTAssertEqual(colorsArr.map(\.cgColor), strokeColor.values as? [CGColor])
        XCTAssertEqual("strokeColor", strokeColor.keyPath)

        let fillColor = CALayer.VALayerKeyframeAnimation.fillColor(values: colorsArr)
        XCTAssertEqual(colorsArr.map(\.cgColor), fillColor.values as? [CGColor])
        XCTAssertEqual("fillColor", fillColor.keyPath)

        let path = CALayer.VALayerKeyframeAnimation.path(values: pathsArr)
        XCTAssertEqual(pathsArr.map(\.cgPath), path.values as? [CGPath])
        XCTAssertEqual("path", path.keyPath)
    }
}
