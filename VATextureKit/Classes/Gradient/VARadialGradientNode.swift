//
//  VARadialGradientNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VARadialGradientNode: VABaseGradientNode {
    public enum Gradient {
        case centered
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
        case custom(startPoint: CGPoint, endPoint: CGPoint)
    }

    private var blend: BlendMode?
    private var gradient: Gradient?
    
    public convenience init(gradient: Gradient, blend: BlendMode? = nil) {
        self.init(type: .radial)

        self.blend = blend
        self.gradient = gradient
    }

    open override func didLoad() {
        super.didLoad()

        switch gradient {
        case .centered:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        case .topLeft:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        case .topRight:
            gradientLayer.startPoint = CGPoint(x: 1, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        case .bottomLeft:
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        case .bottomRight:
            gradientLayer.startPoint = CGPoint(x: 1, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        case let .custom(startPoint, endPoint):
            gradientLayer.startPoint = startPoint
            gradientLayer.endPoint = endPoint
        case .none:
            break
        }
        if let blend {
            blendMode = blend
        }
    }
}
