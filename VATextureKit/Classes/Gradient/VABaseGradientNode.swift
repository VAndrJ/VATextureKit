//
//  VABaseGradientNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VABaseGradientNode: ASDisplayNode {
    public var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    private var gradientType: CAGradientLayerType?
    
    public convenience init(type: CAGradientLayerType) {
        self.init { CAGradientLayer() }

        self.gradientType = type
    }

    open override func didLoad() {
        super.didLoad()

        if let gradientType {
            gradientLayer.type = gradientType
        }
    }
    
    public func update(colors: (color: UIColor, location: NSNumber)...) {
        gradientLayer.colors = colors.map(\.color.cgColor)
        gradientLayer.locations = colors.map(\.location)
    }
}
