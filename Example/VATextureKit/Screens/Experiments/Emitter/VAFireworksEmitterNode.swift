//
//  VAFireworksEmitterNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 01.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class VAFireworksEmitterNode: VAEmitterNode {
    struct DTO {
        var number = 2
        var dotColor: UIColor = .lightGray
        var dotSize = CGSize(same: 12)
    }

    let data: DTO

    private lazy var image = UIImage.render(color: data.dotColor, size: data.dotSize).cgImage

    init(data: DTO) {
        self.data = data

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

        setEmitterPosition(bounds.position)
    }

    override func start() {
        guard !isStarted else { return }

        emitterLayer.beginTime = CACurrentMediaTime()
        emitterLayer.emitterCells = (0..<data.number).map { index in
            let birthRate = (Float(index + 1) / Float(data.number)) + 0.5
            let lifetime = Float.random(in: 0.75...1.25)
            let fireworkCell = CAEmitterCell()
            fireworkCell.contents = image
            fireworkCell.birthRate = 50000
            fireworkCell.lifetime = 2
            fireworkCell.beginTime = CFTimeInterval(.random(in: 0.3...0.9) * lifetime)
            fireworkCell.duration = CFTimeInterval(.random(in: 0.05...0.2) * lifetime)
            fireworkCell.velocity = .random(in: 50...160)
            fireworkCell.emissionRange = 360.0 * (.pi / 180.0)
            fireworkCell.spin = 114.6 * (.pi / 180.0)
            fireworkCell.scale = 0.1
            fireworkCell.scaleSpeed = 0.06
            fireworkCell.alphaSpeed = -0.6
            let locationCell = CAEmitterCell()
            locationCell.scale = 0
            locationCell.birthRate = birthRate
            locationCell.lifetime = lifetime
            locationCell.color = UIColor.white.cgColor
            locationCell.redRange = 1
            locationCell.greenRange = 1
            locationCell.blueRange = 1
            locationCell.velocity = 200
            locationCell.velocityRange = 50
            locationCell.emissionLongitude = .random(in: -.pi...CGFloat.pi)
            locationCell.emissionRange = .pi
            locationCell.emitterCells = [fireworkCell]

            return locationCell
        }

        super.start()
    }
}

public extension UIImage {

    static func render(color: UIColor, size: CGSize, isEllipse: Bool = false) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        return UIGraphicsImageRenderer(bounds: rect).image { context in
            context.cgContext.setFillColor(color.cgColor)
            if isEllipse {
                context.cgContext.addEllipse(in: rect)
            } else {
                context.cgContext.addRect(rect)
            }
            context.cgContext.drawPath(using: .fill)
        }
    }
}