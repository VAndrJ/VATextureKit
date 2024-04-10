//
//  VARainEmitterNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 03.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class VARainEmitterNode: VAEmitterNode {
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
                UIImage.render(color: .white, size: .init(width: 1, height: 3), isEllipse: true).cgImage,
            ]
        case .medium:
            images = [
                UIImage.render(color: .white, size: .init(width: 1, height: 3), isEllipse: true).cgImage,
                UIImage.render(color: .white, size: .init(width: 1, height: 6), isEllipse: true).cgImage,
                UIImage.render(color: .white, size: .init(width: 1, height: 9), isEllipse: true).cgImage,
            ]
        case .heavy:
            images = [
                UIImage.render(color: .white, size: .init(width: 1, height: 3), isEllipse: true).cgImage,
                UIImage.render(color: .white, size: .init(width: 1, height: 6), isEllipse: true).cgImage,
                UIImage.render(color: .white, size: .init(width: 1, height: 9), isEllipse: true).cgImage,
                UIImage.render(color: .white, size: .init(width: 2, height: 2), isEllipse: true).cgImage,
                UIImage.render(color: .white, size: .init(width: 2, height: 2), isEllipse: true).cgImage,
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

        setEmitterPosition(.init(x: bounds.midX, y: bounds.minY - 10))
        setEmitterSize(bounds.size)
    }

    override func start() {
        guard !isStarted else { return }

        emitterLayer.emitterShape = .line
        emitterLayer.emitterMode = .surface
        emitterLayer.renderMode = .unordered
        emitterLayer.emitterCells = images.map { image in
            let cell = CAEmitterCell()
            cell.contents = image
            cell.birthRate = 100
            cell.lifetime = 10
            cell.lifetimeRange = 2
            cell.velocity = 200
            cell.velocityRange = 50
            cell.yAcceleration = 50
            cell.emissionLongitude = .pi
            cell.scale = 0.3
            cell.scaleRange = 0.2
            cell.scaleSpeed = 0.05
            cell.color = UIColor.white.cgColor
            cell.alphaRange = 0.8
            cell.alphaSpeed = -0.7
            cell.contentsRect = .init(origin: .zero, size: .init(same: 1))

            return cell
        }

        super.start()
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBlue
    }
}
