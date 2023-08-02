//
//  VAConfettiEmitterNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 02.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class VAConfettiEmitterNode: VAEmitterNode {
    struct DTO {
        var number = 2
        var dotColor: UIColor = .lightGray
        var dotSize = CGSize(same: 12)
        var confettiTypes: [ConfettiType] = {
            let colors: [UIColor] = [.orange, .red, .green, .blue, .yellow, .cyan, .purple, .gray, .magenta, .orange]
            return (colors + colors.map { $0.withAlphaComponent(0.75) } + colors.map { $0.withAlphaComponent(0.5) }).map {
                ConfettiType(color: $0)
            }
        }()
    }

    let data: DTO

    private lazy var image: CGImage? = createImage(color: data.dotColor, size: data.dotSize)?.cgImage

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

    override func layerBoundsDidChanged(to newFrame: CGRect) {
        layer.emitterPosition = CGPoint(x: newFrame.midX, y: newFrame.minY - 100)
    }

    override func start() {
        if layer.emitterCells == nil {
            layer.emitterCells = createConfettiCells(scale: 1, speed: 1) + createConfettiCells(scale: 0.5, speed: 0.9) + createConfettiCells(scale: 0.1, speed: 0.8)
        }
        layer.beginTime = CACurrentMediaTime()
        addBehaviors(to: layer)
        super.start()
        mainAsync(after: 1) { [self] in
            stop()
        }
    }

    private func createImage(color: UIColor, size: CGSize) -> UIImage? {
        UIGraphicsImageRenderer(size: size).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }

    func createConfettiCells(scale: CGFloat, speed: Float) -> [CAEmitterCell] {
        data.confettiTypes.map { confettiType in
            let cell = CAEmitterCell()
            cell.name = confettiType.name
            cell.beginTime = 0.1
            cell.birthRate = 100
            cell.contents = confettiType.image.cgImage
            cell.emissionRange = .pi
            cell.lifetime = 10
            cell.spin = 4
            cell.spinRange = 8
            cell.velocityRange = 0
            cell.yAcceleration = 0
            cell.scale = scale
            cell.speed = speed
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
                attractorBehavior(for: layer)
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
        let behavior = createBehavior(type: "attractor")
        behavior.setValue("attractor", forKeyPath: "name")
        behavior.setValue(-290, forKeyPath: "falloff")
        behavior.setValue(290, forKeyPath: "radius")
        behavior.setValue(10, forKeyPath: "stiffness")
        behavior.setValue(
            CGPoint(
                x: emitterLayer.emitterPosition.x,
                y: emitterLayer.emitterPosition.y + 20
            ),
            forKeyPath: "position"
        )
        behavior.setValue(-70, forKeyPath: "zPosition")

        return behavior
    }

    func addAnimations(to layer: CAEmitterLayer) {
        addAttractorAnimation(to: layer)
        addBirthrateAnimation(to: layer)
        addGravityAnimation(to: layer)
    }

    func addAttractorAnimation(to layer: CALayer) {
        let animation = CAKeyframeAnimation()
        animation.duration = 3
        animation.keyTimes = [0, 0.4]
        animation.values = [80, 5]
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        layer.add(animation, forKey: "emitterBehaviors.attractor.stiffness")
    }

    func addBirthrateAnimation(to layer: CALayer) {
        let animation = CABasicAnimation()
        animation.duration = 0.5
        animation.fromValue = 1
        animation.toValue = 0
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        layer.add(animation, forKey: "birthRate")
    }

    func addGravityAnimation(to layer: CALayer) {
        let animation = CAKeyframeAnimation()
        animation.duration = 10
        animation.keyTimes = [0.05, 0.1, 0.2, 0.5, 1]
        animation.values = [0, 100, 1000, 10000, 0]
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        for type in data.confettiTypes {
            layer.add(animation, forKey: "emitterCells.\(type.name).yAcceleration")
        }
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
