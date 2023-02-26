//
//  VABaseGradientNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

open class VABaseGradientNode: ASDisplayNode {
    public var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    public convenience init(type: CAGradientLayerType) {
        self.init { CAGradientLayer() }
        
        gradientLayer.type = type
    }
    
    public func update(colors: (color: UIColor, location: NSNumber)...) {
        gradientLayer.colors = colors.map(\.color.cgColor)
        gradientLayer.locations = colors.map(\.location)
    }
}
