//
//  VATextEmitterNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 03.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class VATextEmitterNode: VAEmitterNode, @unchecked Sendable {
    struct Context {
        var strings: [String] = Array("asdfghjklqwertyuiopzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890").map { String($0) }
    }

    let context: Context

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

        setEmitterPosition(bounds.position)
        setEmitterSize(bounds.size)
    }

    override func start() {
        guard !isStarted else { return }

        emitterLayer.emitterShape = .rectangle
        emitterLayer.emitterMode = .outline
        emitterLayer.emitterCells = context.strings.map { string in
            let fontSize = CGFloat.random(in: 8...24)
            let fontWeight = [UIFont.Weight.light, .thin, .regular, .semibold].randomElement()! // swiftlint:disable:this force_unwrapping
            let font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
            let size = (string as NSString).size(withAttributes: [.font: font])
            let textLayer = CATextLayer()
            textLayer.frame = CGRect(origin: CGPoint.zero, size: size)
            textLayer.string = string
            textLayer.font = font
            textLayer.fontSize = fontSize
            let cell = CAEmitterCell()
            cell.contents = UIImage.render(layer: textLayer).cgImage
            cell.color = UIColor.gray.cgColor
            cell.alphaSpeed = -0.25
            cell.scale = 0.3
            cell.scaleRange = -0.2
            cell.scaleSpeed = -0.1
            cell.spinRange = .pi * 2
            cell.emissionRange = .pi * 2
            cell.birthRate = Float.random(in: 1...5)
            cell.lifetime = 4
            cell.velocity = 50
            cell.velocityRange = CGFloat.random(in: 75...125)

            return cell
        }

        super.start()
    }
}
