//
//  VARadialGradientNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

open class VARadialGradientNode: VABaseGradientNode, @unchecked Sendable {
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

    open override func viewDidLoad() {
        super.viewDidLoad()

        switch gradient {
        case .centered:
            layer.startPoint = CGPoint(xy: 0.5)
            layer.endPoint = CGPoint(xy: 1)
        case .topLeft:
            layer.startPoint = CGPoint(xy: 0)
            layer.endPoint = CGPoint(xy: 1)
        case .topRight:
            layer.startPoint = CGPoint(x: 1, y: 0)
            layer.endPoint = CGPoint(x: 0, y: 1)
        case .bottomLeft:
            layer.startPoint = CGPoint(x: 0, y: 1)
            layer.endPoint = CGPoint(x: 1, y: 0)
        case .bottomRight:
            layer.startPoint = CGPoint(xy: 1)
            layer.endPoint = CGPoint(xy: 0)
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
