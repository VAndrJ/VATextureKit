//
//  VAEmitterNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 01.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class VAFireworksNode: VAEmitterNode {
    var numberOfFireworks = 2

    private lazy var image: CGImage? = createImage(color: .lightGray, size: CGSize(same: 12))?.cgImage

    override func didLoad() {
        super.didLoad()

        start()
    }

    override func layerBoundsDidChanged(to newFrame: CGRect) {
        layer.emitterPosition = newFrame.position
    }

    override func start() {
        guard !layer.isStarted else { return }

        layer.beginTime = CACurrentMediaTime()
        layer.emitterCells = (0..<numberOfFireworks).map { index in
            let birthRate = (Float(index + 1) / Float(numberOfFireworks)) + 0.5
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

    private func createImage(color: UIColor, size: CGSize) -> UIImage? {
        UIGraphicsImageRenderer(size: size).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}
