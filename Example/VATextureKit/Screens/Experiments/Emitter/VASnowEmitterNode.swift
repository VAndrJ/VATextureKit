//
//  VASnowEmitterNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 04.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class VASnowEmitterNode: VAEmitterNode, @unchecked Sendable {
    struct Context {
        enum Strength {
            case small
            case medium
            case heavy
        }

        var strength: Strength = .heavy
    }

    let context: Context

    private lazy var images: [CGImage] = {
        let images: [CGImage?]
        switch context.strength {
        case .small:
            images = [
                UIImage.render(color: .white, size: .init(same: 3), isEllipse: true).cgImage,
            ]
        case .medium:
            images = [
                UIImage.render(color: .white, size: .init(same: 3), isEllipse: true).cgImage,
                UIImage.render(color: .white, size: .init(same: 6), isEllipse: true).cgImage,
                UIImage.render(color: .white, size: .init(same: 9), isEllipse: true).cgImage,
            ]
        case .heavy:
            images = [
                UIImage.render(color: .white, size: .init(same: 3), isEllipse: true).cgImage,
                UIImage.render(color: .white, size: .init(same: 6), isEllipse: true).cgImage,
                UIImage.render(color: .white, size: .init(same: 9), isEllipse: true).cgImage,
                UIImage.render(color: .white, size: .init(same: 2), isEllipse: true).cgImage,
            ]
        }

        return images.compactMap { $0 }
    }()

    init(context: Context) {
        self.context = context

        super.init()
    }

    override func didEnterVisibleState() {
        super.didEnterVisibleState()

        start()
    }

    override func didExitVisibleState() {
        super.didExitVisibleState()

        forceStop()
    }

    override func layout() {
        super.layout()

        setEmitterPosition(.init(x: bounds.midX, y: bounds.minY - 20))
        setEmitterSize(bounds.size)
    }

    override func start() {
        guard !isStarted else { return }

        emitterLayer.emitterShape = .line
        emitterLayer.emitterMode = .surface
        emitterLayer.renderMode = .unordered
        emitterLayer.addBehaviors([emitterLayer.getHorizontalWaveBehavior(frequency: 1)])
        emitterLayer.emitterCells = images.map { image in
            let cell = CAEmitterCell()
            cell.contents = image
            cell.lifetime = 10
            cell.velocityRange = 100
            cell.emissionLongitude = .pi
            cell.emissionRange = .pi / 4
            cell.scale = 0.2
            cell.scaleRange = 0.1
            cell.scaleSpeed = 0.02
            cell.color = UIColor.white.cgColor
            cell.alphaRange = 0.8
            cell.alphaSpeed = -0.2
            cell.contentsRect = .init(origin: .zero, size: .init(same: 1))
            switch context.strength {
            case .small:
                cell.birthRate = 10
                cell.velocity = 15
                cell.yAcceleration = 15
            case .medium:
                cell.birthRate = 30
                cell.velocity = 20
                cell.yAcceleration = 20
            case .heavy:
                cell.birthRate = 50
                cell.velocity = 30
                cell.scaleRange = 0.3
                cell.yAcceleration = 50
            }
            
            return cell
        }

        super.start()
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBlue
    }
}
