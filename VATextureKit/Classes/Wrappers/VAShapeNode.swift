//
//  VAShapeNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 28.07.2023.
//

import AsyncDisplayKit

/// `CAShapeLayer` wrapper node
open class VAShapeNode: ASDisplayNode {
    public struct Context {
        let fillColor: UIColor
        let strokeColor: UIColor
        let backgroundColor: UIColor
        let borderColor: UIColor
        let shadowColor: UIColor

        public init(
            fillColor: UIColor = .clear,
            strokeColor: UIColor = .clear,
            backgroundColor: UIColor = .clear,
            borderColor: UIColor = .clear,
            shadowColor: UIColor = .clear
        ) {
            self.fillColor = fillColor
            self.strokeColor = strokeColor
            self.backgroundColor = backgroundColor
            self.borderColor = borderColor
            self.shadowColor = shadowColor
        }
    }

    public override var layer: CAShapeLayer { super.layer as! CAShapeLayer }

    private var context: Context!
    private var observation: NSKeyValueObservation?

    public convenience init(context: Context) {
        self.init { CAShapeLayer() }

        self.context = context
    }

    @MainActor
    open override func didLoad() {
        super.didLoad()

        layer.fillColor = context.fillColor.cgColor
        layer.strokeColor = context.strokeColor.cgColor
        layer.backgroundColor = context.backgroundColor.cgColor
        layer.borderColor = context.borderColor.cgColor
        layer.shadowColor = context.shadowColor.cgColor
        if overrides(#selector(layerBoundsDidChanged(to:))) {
            observation = layer.observe(\.bounds, options: [.new], changeHandler: { [weak self] _, change in
                guard let newValue = change.newValue else { return }

                ensureOnMain {
                    self?.layerBoundsDidChanged(to: newValue)
                }
            })
        }
    }

    @objc open func layerBoundsDidChanged(to rect: CGRect) {}

    public func setLineWidth(_ value: CGFloat) {
        ensureOnMain { [layer] in
            layer.lineWidth = value
        }
    }

    public func setLineDashPattern(_ values: [NSNumber]?) {
        ensureOnMain { [layer] in
            layer.lineDashPattern = values
        }
    }

    public func setLineJoin(_ value: CAShapeLayerLineJoin) {
        ensureOnMain { [layer] in
            layer.lineJoin = value
        }
    }

    public func setPath(_ value: UIBezierPath?) {
        setCGPath(value?.cgPath)
    }

    public func setCGPath(_ value: CGPath?) {
        ensureOnMain { [layer] in
            layer.path = value
        }
    }

    public func setFillRule(_ value: CAShapeLayerFillRule) {
        ensureOnMain { [layer] in
            layer.fillRule = value
        }
    }

    public func setFillColor(_ value: UIColor?) {
        setFillCGColor(value?.cgColor)
    }

    public func setFillCGColor(_ value: CGColor?) {
        ensureOnMain { [layer] in
            layer.fillColor = value
        }
    }

    public func setStrokeColor(_ value: UIColor?) {
        setStrokeCGColor(value?.cgColor)
    }

    public func setStrokeCGColor(_ value: CGColor?) {
        ensureOnMain { [layer] in
            layer.strokeColor = value
        }
    }

    public func setBackgroundColor(_ value: UIColor?) {
        setBackgroundCGColor(value?.cgColor)
    }

    public func setBackgroundCGColor(_ value: CGColor?) {
        ensureOnMain { [layer] in
            layer.backgroundColor = value
        }
    }

    public func setBorderColor(_ value: UIColor?) {
        setBorderCGColor(value?.cgColor)
    }

    public func setBorderCGColor(_ value: CGColor?) {
        ensureOnMain { [layer] in
            layer.borderColor = value
        }
    }

    public func setShadowColor(_ value: UIColor?) {
        setShadowCGColor(value?.cgColor)
    }

    public func setShadowCGColor(_ value: CGColor?) {
        ensureOnMain { [layer] in
            layer.shadowColor = value
        }
    }

    public func setStrokeStart(_ value: CGFloat) {
        ensureOnMain { [layer] in
            layer.strokeStart = value
        }
    }

    public func setStrokeEnd(_ value: CGFloat) {
        ensureOnMain { [layer] in
            layer.strokeEnd = value
        }
    }

    public func setMiterLimit(_ value: CGFloat) {
        ensureOnMain { [layer] in
            layer.miterLimit = value
        }
    }

    public func setLineDashPhase(_ value: CGFloat) {
        ensureOnMain { [layer] in
            layer.lineDashPhase = value
        }
    }

    public func setLineCap(_ value: CAShapeLayerLineCap) {
        ensureOnMain { [layer] in
            layer.lineCap = value
        }
    }
}
