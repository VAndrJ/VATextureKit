//
//  VAShapeNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 28.07.2023.
//

import AsyncDisplayKit

open class VAShapeNode: ASDisplayNode {
    public struct DTO {
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

    private var data: DTO!

    public convenience init(data: DTO) {
        self.init { CAShapeLayer() }

        self.data = data
    }

    open override func didLoad() {
        super.didLoad()

        layer.fillColor = data.fillColor.cgColor
        layer.strokeColor = data.strokeColor.cgColor
        layer.backgroundColor = data.backgroundColor.cgColor
        layer.borderColor = data.borderColor.cgColor
        layer.shadowColor = data.shadowColor.cgColor
    }

    public func setLineWidth(_ value: CGFloat) {
        ensureOnMain { [self] in
            layer.lineWidth = value
        }
    }

    public func setLineDashPattern(_ values: [NSNumber]?) {
        ensureOnMain { [self] in
            layer.lineDashPattern = values
        }
    }

    public func setLineJoin(_ value: CAShapeLayerLineJoin) {
        ensureOnMain { [self] in
            layer.lineJoin = value
        }
    }

    public func setPath(_ value: UIBezierPath?) {
        setCGPath(value?.cgPath)
    }

    public func setCGPath(_ value: CGPath?) {
        ensureOnMain { [self] in
            layer.path = value
        }
    }

    public func setFillRule(_ value: CAShapeLayerFillRule) {
        ensureOnMain { [self] in
            layer.fillRule = value
        }
    }

    public func setFillColor(_ value: UIColor?) {
        setFillCGColor(value?.cgColor)
    }

    public func setFillCGColor(_ value: CGColor?) {
        ensureOnMain { [self] in
            layer.fillColor = value
        }
    }

    public func setStrokeColor(_ value: UIColor?) {
        setStrokeCGColor(value?.cgColor)
    }

    public func setStrokeCGColor(_ value: CGColor?) {
        ensureOnMain { [self] in
            layer.strokeColor = value
        }
    }

    public func setBackgroundColor(_ value: UIColor?) {
        setBackgroundCGColor(value?.cgColor)
    }

    public func setBackgroundCGColor(_ value: CGColor?) {
        ensureOnMain { [self] in
            layer.backgroundColor = value
        }
    }

    public func setBorderColor(_ value: UIColor?) {
        setBorderCGColor(value?.cgColor)
    }

    public func setBorderCGColor(_ value: CGColor?) {
        ensureOnMain { [self] in
            layer.borderColor = value
        }
    }

    public func setShadowColor(_ value: UIColor?) {
        setShadowCGColor(value?.cgColor)
    }

    public func setShadowCGColor(_ value: CGColor?) {
        ensureOnMain { [self] in
            layer.shadowColor = value
        }
    }

    public func setStrokeStart(_ value: CGFloat) {
        ensureOnMain { [self] in
            layer.strokeStart = value
        }
    }

    public func setStrokeEnd(_ value: CGFloat) {
        ensureOnMain { [self] in
            layer.strokeEnd = value
        }
    }

    public func setMiterLimit(_ value: CGFloat) {
        ensureOnMain { [self] in
            layer.miterLimit = value
        }
    }

    public func setLineDashPhase(_ value: CGFloat) {
        ensureOnMain { [self] in
            layer.lineDashPhase = value
        }
    }

    public func setLineCap(_ value: CAShapeLayerLineCap) {
        ensureOnMain { [self] in
            layer.lineCap = value
        }
    }
}
