//
//  VABaseGradientNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

open class VABaseGradientNode: VASimpleDisplayNode, @unchecked Sendable {
    public override var layer: CAGradientLayer { super.layer as! CAGradientLayer }

    private var gradientType: CAGradientLayerType!
    
    public convenience init(type: CAGradientLayerType) {
        self.init { CAGradientLayer() }

        self.gradientType = type
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        layer.type = gradientType
    }

    public func update(colors: (color: UIColor, location: NSNumber)...) {
        ensureOnMain {
            layer.colors = colors.map(\.color.cgColor)
            layer.locations = colors.map(\.location)
        }
    }
}
