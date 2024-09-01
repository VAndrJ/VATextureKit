//
//  VALinearGradientNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

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

    private var blend: BlendMode?
    private var gradient: Gradient?
    
    public convenience init(gradient: Gradient, blend: BlendMode? = nil) {
        self.init(type: .axial)

        self.blend = blend
        self.gradient = gradient
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        switch gradient {
        case .vertical:
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint(x: 0.5, y: 1)
        case .horizontal:
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint(x: 1, y: 0.5)
        case let .diagonal(diagonal):
            switch diagonal {
            case .bottomLeftToTopRight:
                layer.startPoint = CGPoint(x: 0, y: 1)
                layer.endPoint = CGPoint(x: 1, y: 0)
            case .bottomRightToTopLeft:
                layer.startPoint = CGPoint(xy: 1)
                layer.endPoint = CGPoint(xy: 0)
            case .topLeftToBottomRight:
                layer.startPoint = CGPoint(xy: 0)
                layer.endPoint = CGPoint(xy: 1)
            case .topRightToBottomLeft:
                layer.startPoint = CGPoint(x: 1, y: 0)
                layer.endPoint = CGPoint(x: 0, y: 1)
            }
        case let .custom(startPoint, endPoint):
            layer.startPoint = startPoint
            layer.endPoint = endPoint
        case .none:
            break
        }
        if let blend {
            blendMode = blend
        }
    }
}
