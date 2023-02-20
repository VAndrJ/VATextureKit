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
    
    public convenience init(gradient: Gradient) {
        self.init(type: .radial)
        
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
        }
    }
}
