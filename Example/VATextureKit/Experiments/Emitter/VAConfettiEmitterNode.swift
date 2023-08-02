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
        var startPoint: StartPoint
        var confettiTypes: [ConfettiType] = {
            let colors: [UIColor] = [.orange, .red, .green, .blue, .yellow, .cyan, .purple, .gray, .magenta, .orange]
            return (colors + colors.map { $0.withAlphaComponent(0.8) } + colors.map { $0.withAlphaComponent(0.6) } + colors.map { $0.withAlphaComponent(0.4) }).map {
                ConfettiType(color: $0)
            }
        }()
    }

    let data: DTO

    init(data: DTO) {
        self.data = data

        super.init()
    }

    override func didLoad() {
        super.didLoad()

        onAnimationsEnded = self ?>> { $0.begin }
    }

    override func didEnterVisibleState() {
        super.didEnterVisibleState()

        begin()
    }

    override func didExitVisibleState() {
        super.didExitVisibleState()

        forceStop()
    }

    override func layout() {
        super.layout()

        let position: CGPoint
        switch data.startPoint {
        case .center:
            position = bounds.position
        case .topCenter:
            position = CGPoint(x: bounds.midX, y: bounds.minY - 150)
        case .bottomRight:
            position = CGPoint(x: bounds.maxX + 100, y: bounds.maxY + 100)
        case .bottomLeft:
            position = CGPoint(x: bounds.minX - 100, y: bounds.maxY + 100)
        }
        setEmitterPosition(position)
        begin()
    }

    func begin() {
        guard bounds != .zero && !isStarted else { return }

        switch data.startPoint {
        case .center, .topCenter:
            emitterLayer.emitterSize = CGSize(same: 100)
        case .bottomRight, .bottomLeft:
            emitterLayer.emitterSize = CGSize(same: 50)
        }
        emitterLayer.emitterShape = .sphere
        emitterLayer.emitterMode = .volume
        emitterLayer.beginTime = CACurrentMediaTime()
        emitterLayer.emitterCells = data.confettiTypes.map { confettiType in
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
            cell.scale = .random(in: 0.1...1)
            cell.speed = 1
            cell.setValue("plane", forKey: "particleType")
            cell.setValue(Double.pi, forKey: "orientationRange")
            cell.setValue(Double.pi / 2, forKey: "orientationLongitude")
            cell.setValue(Double.pi / 2, forKey: "orientationLatitude")

            return cell
        }
        addBehaviors(to: emitterLayer)
        addAnimations(to: emitterLayer)
    }

    func addBehaviors(to layer: VAEmitterLayer) {
        let positionPoint: CGPoint
        switch data.startPoint {
        case .center:
            positionPoint = CGPoint(
                x: emitterPosition.x,
                y: emitterPosition.y
            )
        case .topCenter:
            positionPoint = CGPoint(
                x: emitterPosition.x,
                y: emitterPosition.y - 10
            )
        case .bottomLeft:
            positionPoint = CGPoint(
                x: emitterPosition.x - 30,
                y: emitterPosition.y + 90
            )
        case .bottomRight:
            positionPoint = CGPoint(
                x: emitterPosition.x + 30,
                y: emitterPosition.y + 90
            )
        }
        switch data.startPoint {
        case .bottomLeft, .bottomRight:
            layer.addBehaviors([
                layer.getHorizontalWaveBehavior(),
                layer.getAttractorBehavior(position: positionPoint, stiffness: 40),
            ])
        case .center, .topCenter:
            layer.addBehaviors([
                layer.getHorizontalWaveBehavior(),
                layer.getVerticalWaveBehavior(),
                layer.getAttractorBehavior(position: positionPoint, stiffness: 10),
            ])
        }
    }

    func addAnimations(to layer: VAEmitterLayer) {
        start()
        mainAsync(after: 0.75) { [self] in
            stop()
        }
        layer.addAttractorStiffnessAnimation(values: [data.startPoint == .topCenter ? 10 : 40, 3])
        layer.addBirthrateAnimation()
        layer.addGravityAnimation(keys: data.confettiTypes.map(\.name))
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
                return CGRect(width: 3, height: 3)
            case 3, 4:
                return CGRect(width: 4, height: 2)
            default:
                return CGRect(width: 3, height: 1)
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
