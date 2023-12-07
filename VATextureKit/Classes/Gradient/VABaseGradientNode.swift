//
//  VABaseGradientNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VABaseGradientNode: ASDisplayNode {
    public override var layer: CAGradientLayer { super.layer as! CAGradientLayer }

    private var gradientType: CAGradientLayerType!
    
    public convenience init(type: CAGradientLayerType) {
        self.init { CAGradientLayer() }

        self.gradientType = type
    }

    @MainActor
    open override func didLoad() {
        super.didLoad()

        layer.type = gradientType
    }
    
    public func update(colors: (color: UIColor, location: NSNumber)...) {
        ensureOnMain { [self] in
            layer.colors = colors.map(\.color.cgColor)
            layer.locations = colors.map(\.location)
        }
    }
}
