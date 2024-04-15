//
//  VAConfettiEmitterNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 02.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class VAConfettiEmitterNode: VAEmitterNode {
    enum StartPoint {
        case center
        case topCenter
        case bottomRight
        case bottomLeft
    }

    struct Context {
        var startPoint: StartPoint
        var confettiTypes: [ConfettiType] = {
            var confettiArray: [ConfettiType] = []
            for color in [UIColor.orange, .red, .green, .blue, .yellow, .cyan, .purple, .gray, .magenta, .orange] {
                confettiArray.append(ConfettiType(color: .fromAlpha(foreground: color)))
                for alpha in [0.8, 0.6, 0.4] {
                    confettiArray.append(ConfettiType(color: .fromAlpha(foreground: color.withAlphaComponent(alpha))))
                }
            }
            
            return confettiArray
        }()
    }

    let context: Context

    init(context: Context) {
        self.context = context

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
        switch context.startPoint {
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

        switch context.startPoint {
        case .center, .topCenter:
            emitterLayer.emitterSize = CGSize(same: 100)
        case .bottomRight, .bottomLeft:
            emitterLayer.emitterSize = CGSize(same: 50)
        }
        emitterLayer.emitterShape = .sphere
        emitterLayer.emitterMode = .volume
        emitterLayer.beginTime = CACurrentMediaTime()
        emitterLayer.emitterCells = context.confettiTypes.map { confettiType in
            let cell = CAEmitterCell()
            cell.name = confettiType.name
            cell.contents = confettiType.image.cgImage
            cell.beginTime = 0.1
            cell.birthRate = 50
            cell.emissionRange = .pi
            cell.lifetime = 5
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
        switch context.startPoint {
        case .center:
            positionPoint = emitterPosition
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
        switch context.startPoint {
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
        layer.addAttractorStiffnessAnimation(
            values: [context.startPoint == .topCenter ? 10 : 40, 3],
            duration: 1
        )
        layer.addBirthRateAnimation(duration: 0.75)
        layer.addGravityAnimation(keys: context.confettiTypes.map(\.name), duration: 5)
    }
}

final class ConfettiType {
    let color: UIColor
    let size: CGSize
    let name = UUID().uuidString
    private(set) lazy var image = UIImage.render(color: color, size: size, isEllipse: Bool.random())

    init(color: UIColor) {
        self.color = color
        self.size = {
            switch Int.random(in: 0...4) {
            case 1, 2:
                return CGSize(width: 3, height: 3)
            case 3, 4:
                return CGSize(width: 4, height: 2)
            default:
                return CGSize(width: 3, height: 1)
            }
        }()
    }
}
