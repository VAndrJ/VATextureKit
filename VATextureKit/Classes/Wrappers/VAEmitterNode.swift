//
//  VAEmitterNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 02.08.2023.
//

import AsyncDisplayKit

open class VAEmitterNode: VADisplayNode {
    open override var layer: CAEmitterLayer { super.layer as! CAEmitterLayer } // swiftlint:disable:this force_cast
    public var onAnimationsEnded: (() -> Void)?

    private var observation: NSKeyValueObservation?

    public override init() {
        super.init()

        setLayerBlock {
            let layer = CAEmitterLayer()
            layer.stop()
            layer.masksToBounds = true
            return layer
        }
    }

    open func start() {
        layer.start()
    }

    open func stop() {
        let lifetime: TimeInterval
        if let emitterCellWithMaxLifetime = layer.emitterCells?.max(by: { $0.lifetime / $0.speed < $1.lifetime / $1.speed }) {
            lifetime = TimeInterval(emitterCellWithMaxLifetime.lifetime)
        } else {
            lifetime = TimeInterval(layer.lifetime)
        }
        mainAsync(after: lifetime + 0.1) { [weak self] in
            self?.onAnimationsEnded?()
        }
        
        layer.stop()
    }

    @objc open func layerBoundsDidChanged(to rect: CGRect) {}

    open override func didLoad() {
        super.didLoad()

        if overrides(#selector(layerBoundsDidChanged(to:))) {
            observation = layer.observe(\.bounds, options: [.new], changeHandler: { [weak self] _, change in
                guard let newValue = change.newValue else { return }

                ensureOnMain {
                    self?.layerBoundsDidChanged(to: newValue)
                }
            })
        }
    }
}

public extension CAEmitterLayer {
    var isStarted: Bool { !(birthRate.isZero || lifetime.isZero) }

    func start(birthRate: Float = 1, lifetime: Float = 1) {
        self.birthRate = birthRate
        self.lifetime = lifetime
    }

    func stop() {
        birthRate = 0
        lifetime = 0
    }
}
