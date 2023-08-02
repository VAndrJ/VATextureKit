//
//  VAConfettiEmitterNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 02.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class VAConfettiEmitterNode: VAEmitterNode {
    enum StartPoint {
        case center
        case topCenter
        case bottomRight
        case bottomLeft
    }

    struct DTO {
        var number = 2
        var dotColor: UIColor = .lightGray
        var dotSize = CGSize(same: 12)
        var confettiTypes: [ConfettiType] = {
            let colors: [UIColor] = [.orange, .red, .green, .blue, .yellow, .cyan, .purple, .gray, .magenta, .orange]
            return (colors + colors.map { $0.withAlphaComponent(0.8) } + colors.map { $0.withAlphaComponent(0.6) } + colors.map { $0.withAlphaComponent(0.4) }).map {
                ConfettiType(color: $0)
            }
        }()
        var startPoint: StartPoint = .topCenter
    }

    let data: DTO

    init(data: DTO) {
        self.data = data

        super.init()
    }

    override func didLoad() {
        super.didLoad()

        layer.emitterSize = CGSize(same: 100)
        layer.emitterShape = .sphere
        layer.emitterMode = .volume
        onAnimationsEnded = self ?>> { $0.start }
        mainAsync(after: 1) { [self] in
            start()
        }
    }

    override func layerBoundsDidChanged(to rect: CGRect) {
        switch data.startPoint {
        case .center:
            layer.emitterPosition = rect.position
        case .topCenter:
            layer.emitterPosition = CGPoint(x: rect.midX, y: rect.minY - 100)
        case .bottomRight:
            layer.emitterPosition = CGPoint(x: rect.maxX + 100, y: rect.maxY + 100)
        case .bottomLeft:
            layer.emitterPosition = CGPoint(x: rect.minX - 100, y: rect.maxY + 100)
        }
    }

    override func start() {
        layer.beginTime = CACurrentMediaTime()
        if layer.emitterCells == nil {
            layer.emitterCells = createConfettiCells(scale: .random(in: 0.5...1))
        }
        super.start()
        addBehaviors(to: layer)
        addAnimations(to: layer)
        mainAsync(after: 1) { [self] in
            stop()
        }
    }

    func createConfettiCells(scale: CGFloat) -> [CAEmitterCell] {
        data.confettiTypes.map { confettiType in
            let cell = CAEmitterCell()
            cell.name = confettiType.name
            cell.contents = confettiType.image.cgImage
            cell.beginTime = 0.1
            cell.birthRate = 100
            cell.emissionRange = .pi
            cell.lifetime = 10
            cell.spin = 4
            cell.spinRange = 8
            cell.velocityRange = 0
            cell.yAcceleration = 0
            cell.scale = scale
            cell.speed = 1
            cell.setValue("plane", forKey: "particleType")
            cell.setValue(Double.pi, forKey: "orientationRange")
            cell.setValue(Double.pi / 2, forKey: "orientationLongitude")
            cell.setValue(Double.pi / 2, forKey: "orientationLatitude")

            return cell
        }
    }

    func addBehaviors(to layer: CAEmitterLayer) {
        layer.setValue(
            [
                horizontalWaveBehavior(),
                verticalWaveBehavior(),
                attractorBehavior(for: layer),
            ],
            forKey: "emitterBehaviors"
        )
    }

    func horizontalWaveBehavior() -> Any {
        let behavior = createBehavior(type: "wave")
        behavior.setValue([100, 0, 0], forKeyPath: "force")
        behavior.setValue(0.5, forKeyPath: "frequency")
        return behavior
    }

    func verticalWaveBehavior() -> Any {
        let behavior = createBehavior(type: "wave")
        behavior.setValue([0, 500, 0], forKeyPath: "force")
        behavior.setValue(3, forKeyPath: "frequency")
        return behavior
    }

    func attractorBehavior(for emitterLayer: CAEmitterLayer) -> Any {
        let positionPoint: CGPoint
        switch data.startPoint {
        case .center:
            positionPoint = CGPoint(
                x: emitterLayer.emitterPosition.x,
                y: emitterLayer.emitterPosition.y
            )
        case .topCenter:
            positionPoint = CGPoint(
                x: emitterLayer.emitterPosition.x,
                y: emitterLayer.emitterPosition.y - 10
            )
        case .bottomLeft:
            positionPoint = CGPoint(
                x: emitterLayer.emitterPosition.x - 30,
                y: emitterLayer.emitterPosition.y + 90
            )
        case .bottomRight:
            positionPoint = CGPoint(
                x: emitterLayer.emitterPosition.x + 30,
                y: emitterLayer.emitterPosition.y + 90
            )
        }
        let behavior = createBehavior(type: "attractor")
        behavior.setValue(data.startPoint == .topCenter ? 10 : 40, forKeyPath: "stiffness")
        behavior.setValue(positionPoint, forKeyPath: "position")
        behavior.setValue(-70, forKeyPath: "zPosition")
        behavior.setValue("attractor", forKeyPath: "name")
        behavior.setValue(-290, forKeyPath: "falloff")
        behavior.setValue(290, forKeyPath: "radius")

        return behavior
    }

    func dragBehavior() -> Any {
        let behavior = createBehavior(type: "drag")
        behavior.setValue("drag", forKey: "name")
        behavior.setValue(1, forKey: "drag")

        return behavior
    }

    func addAnimations(to layer: CAEmitterLayer) {
        addAttractorAnimation(to: layer, beginValue: data.startPoint == .topCenter ? 10 : 40)
        addBirthrateAnimation(to: layer)
        addGravityAnimation(to: layer)
    }

    func addAttractorAnimation(to layer: CAEmitterLayer, beginValue: CGFloat) {
        let animation = CAKeyframeAnimation()
        animation.duration = 1
        animation.keyTimes = [0, 1]
        animation.values = [beginValue, 1]
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        layer.add(animation, forKey: "emitterBehaviors.attractor.stiffness")
    }

    func addBirthrateAnimation(to layer: CAEmitterLayer) {
        layer.birthRate = 1
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            layer.birthRate = 0
        }
        let animation = CABasicAnimation()
        animation.duration = 0.75
        animation.fromValue = 1
        animation.toValue = 0
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        layer.add(animation, forKey: "birthRate")
        CATransaction.commit()
    }

    func addGravityAnimation(to layer: CALayer) {
        let animation = CAKeyframeAnimation()
        animation.duration = 10
        animation.keyTimes = [0.05, 0.1, 0.2, 0.4, 0.8]
        animation.values = [0, 200, 400, 800, 1600]
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        for type in data.confettiTypes {
            layer.add(animation, forKey: "emitterCells.\(type.name).yAcceleration")
        }
    }

    func addDragAnimation(to layer: CALayer) {
        let animation = CABasicAnimation()
        animation.duration = 0.35
        animation.fromValue = 0
        animation.toValue = 2
        layer.add(animation, forKey: "emitterBehaviors.drag.drag")
    }

    func createBehavior(type: String) -> NSObject {
        guard let behaviorClass = NSClassFromString("CAEmitterBehavior") as? NSObject.Type else {
            return NSObject()
        }
        guard let behaviorWithType = behaviorClass.method(for: NSSelectorFromString("behaviorWithType:")) else {
            return NSObject()
        }
        let castedBehaviorWithType = unsafeBitCast(behaviorWithType, to: (@convention(c)(Any?, Selector, Any?) -> NSObject).self)
        return castedBehaviorWithType(behaviorClass, NSSelectorFromString("behaviorWithType:"), type)
    }
}

class ConfettiType {
    let color: UIColor
    let rect: CGRect
    private(set) lazy var name = UUID().uuidString

    init(color: UIColor) {
        self.color = color
        self.rect = {
            switch Int.random(in: 0...4) {
            case 1, 2:
                return CGRect(width: 4, height: 4)
            case 3, 4:
                return CGRect(width: 5, height: 3)
            default:
                return CGRect(width: 4, height: 2)
            }
        }()
    }

    lazy var image: UIImage = {
        UIGraphicsImageRenderer(bounds: rect).image { context in
            context.cgContext.setFillColor(color.cgColor)
            if Bool.random() {
                context.cgContext.addRect(rect)
            } else {
                context.cgContext.addEllipse(in: rect)
            }
            context.cgContext.drawPath(using: .fill)
        }
    }()
}
