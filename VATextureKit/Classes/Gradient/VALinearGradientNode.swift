//
//  VALinearGradientNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VALinearGradientNode: VABaseGradientNode {
    public enum Diagonal: CaseIterable {
        case topLeftToBottomRight
        case topRightToBottomLeft
        case bottomLeftToTopRight
        case bottomRightToTopLeft
    }
    
    public enum Gradient {
        case vertical
        case horizontal
        case diagonal(Diagonal)
        case custom(startPoint: CGPoint, endPoint: CGPoint)
    }
    
    public convenience init(gradient: Gradient) {
        self.init(type: .axial)
        
        switch gradient {
        case .vertical:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        case .horizontal:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        case let .diagonal(diagonal):
            switch diagonal {
            case .bottomLeftToTopRight:
                gradientLayer.startPoint = CGPoint(x: 0, y: 1)
                gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            case .bottomRightToTopLeft:
                gradientLayer.startPoint = CGPoint(x: 1, y: 1)
                gradientLayer.endPoint = CGPoint(x: 0, y: 0)
            case .topLeftToBottomRight:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            case .topRightToBottomLeft:
                gradientLayer.startPoint = CGPoint(x: 1, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            }
        case let .custom(startPoint, endPoint):
            gradientLayer.startPoint = startPoint
            gradientLayer.endPoint = endPoint
        }
    }
}
