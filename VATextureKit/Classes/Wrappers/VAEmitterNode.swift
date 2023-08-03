//
//  VAEmitterNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 02.08.2023.
//

import AsyncDisplayKit

open class VAEmitterNode: VADisplayNode {
    public var onAnimationsEnded: (() -> Void)?
    public var isStarted: Bool { token != nil }
    public private(set) var emitterPosition: CGPoint = .zero
    public var emitterLayer: VAEmitterLayer {
        if let _emitterLayer {
            return _emitterLayer
        } else {
            let layer = VAEmitterLayer()
            layer.stop()
            layer.masksToBounds = true
            self.layer.addSublayer(layer)
            layer.frame = self.layer.bounds
            layer.emitterPosition = emitterPosition
            _emitterLayer = layer
            return layer
        }
    }

    private var _emitterLayer: VAEmitterLayer?
    private var token: String?

    open override func layout() {
        super.layout()

        _emitterLayer?.frame = layer.bounds
    }

    open func start() {
        start(birthRate: 1)
    }

    public func setEmitterPosition(_ value: CGPoint) {
        emitterPosition = value
        _emitterLayer?.emitterPosition = value
    }

    open func start(birthRate: Float) {
        guard !isStarted else { return }

        emitterLayer.start(birthRate: birthRate)
        token = UUID().uuidString
    }

    open func forceStart() {
        forceStart(birthRate: 1)
    }

    open func forceStart(birthRate: Float) {
        forceStop()

        emitterLayer.start(birthRate: birthRate)
        token = UUID().uuidString
    }

    open func stop() {
        guard isStarted else { return }

        let token = self.token
        let lifetime: TimeInterval
        if let emitterCellWithMaxLifetime = emitterLayer.emitterCells?.max(by: { $0.lifetime / $0.speed < $1.lifetime / $1.speed }) {
            lifetime = TimeInterval(emitterCellWithMaxLifetime.lifetime)
        } else {
            lifetime = TimeInterval(emitterLayer.lifetime)
        }
        _emitterLayer?.stop()
        mainAsync(after: lifetime) { [weak self] in
            guard let self, isStarted, self.token == token else { return }

            _emitterLayer?.removeFromSuperlayer()
            _emitterLayer = nil
            self.token = nil
            mainAsync {
                self.onAnimationsEnded?()
            }
        }
    }

    public func forceStop() {
        _emitterLayer?.stop()
        _emitterLayer?.removeFromSuperlayer()
        _emitterLayer = nil
        token = nil
    }
}

open class VAEmitterLayer: CAEmitterLayer {

    public func addBehaviors(_ array: [Any]) {
        setValue(array, forKey: "emitterBehaviors")
    }

    public func addGravityAnimation(
        keys: [String],
        duration: TimeInterval,
        keyTimes: [NSNumber] = [0.05, 0.1, 0.2, 0.4, 0.8, 1],
        values: [CGFloat] = [0, 200, 400, 800, 1600, 3200],
        timingFunction: CAMediaTimingFunctionName = .easeOut
    ) {
        let animation = CAKeyframeAnimation()
        animation.duration = duration
        animation.keyTimes = keyTimes
        animation.values = values
        animation.timingFunction = CAMediaTimingFunction(name: timingFunction)
        for key in keys {
            add(animation, forKey: "emitterCells.\(key).yAcceleration")
        }
    }

    public func addBirthrateAnimation(
        duration: TimeInterval,
        fromValue: CGFloat = 1,
        toValue: CGFloat = 0,
        timingFunction: CAMediaTimingFunctionName = .easeOut
    ) {
        let animation = CABasicAnimation()
        animation.duration = duration
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.timingFunction = CAMediaTimingFunction(name: timingFunction)
        add(animation, forKey: "birthRate")
    }

    public func addDragAnimation(
        duration: TimeInterval,
        fromValue: CGFloat = 0,
        toValue: CGFloat = 2,
        timingFunction: CAMediaTimingFunctionName = .easeOut
    ) {
        let animation = CABasicAnimation()
        animation.duration = duration
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.timingFunction = CAMediaTimingFunction(name: timingFunction)
        add(animation, forKey: "emitterBehaviors.drag.drag")
    }

    public func addAttractorStiffnessAnimation(
        values: [CGFloat],
        keyTimes: [NSNumber] = [0, 1],
        duration: CFTimeInterval,
        timingFunction: CAMediaTimingFunctionName = .easeOut
    ) {
        let animation = CAKeyframeAnimation()
        animation.duration = duration
        animation.keyTimes = keyTimes
        animation.values = values
        animation.timingFunction = CAMediaTimingFunction(name: timingFunction)
        add(animation, forKey: "emitterBehaviors.attractor.stiffness")
    }

    // axial, planar
    public func getAttractorBehavior(
        attractorType: String = "radial",
        position: CGPoint,
        stiffness: NSNumber,
        zPosition: CGFloat = 70,
        falloff: CGFloat = -290,
        radius: NSNumber = 300,
        orientationLatitude: NSNumber = 0
    ) -> Any {
        let behavior = createBehavior(type: "attractor")
        behavior.setValue("attractor", forKeyPath: "name")
        behavior.setValue(stiffness, forKeyPath: "stiffness")
        behavior.setValue(position, forKeyPath: "position")
        behavior.setValue(zPosition, forKeyPath: "zPosition")
        behavior.setValue(falloff, forKeyPath: "falloff")
        behavior.setValue(radius, forKeyPath: "radius")
        behavior.setValue(attractorType, forKeyPath: "attractorType")
        behavior.setValue(orientationLatitude, forKeyPath: "orientationLatitude")

        return behavior
    }

    public func getHorizontalWaveBehavior(xForce: CGFloat = 100, frequency: CGFloat = 0.5) -> Any {
        getWaveBehavior(force: [xForce, 0, 0], frequency: frequency)
    }

    public func getVerticalWaveBehavior(yForce: CGFloat = 400, frequency: CGFloat = 4) -> Any {
        getWaveBehavior(force: [0, yForce, 0], frequency: frequency)
    }

    public func getWaveBehavior(force: [CGFloat], frequency: CGFloat) -> Any {
        let behavior = createBehavior(type: "wave")
        behavior.setValue(force, forKeyPath: "force")
        behavior.setValue(frequency, forKeyPath: "frequency")

        return behavior
    }

    public func getAlignToMotionBehavior(rotation: CGFloat, preservesDepth: Bool) -> Any {
        let behavior = createBehavior(type: "alignToMotion")
        behavior.setValue(rotation, forKeyPath: "rotation")
        behavior.setValue(preservesDepth, forKeyPath: "preservesDepth")

        return behavior
    }

    public func getValueOverLifeBehavior(keyPath: String, values: [Any]) -> Any {
        let behavior = createBehavior(type: "valueOverLife")
        behavior.setValue(keyPath, forKeyPath: "keyPath")
        behavior.setValue(values, forKeyPath: "values")

        return behavior
    }

    public func getColorOverLifeBehavior(colors: [CGColor], locations: [NSNumber]? = nil) -> Any {
        let behavior = createBehavior(type: "colorOverLife")
        behavior.setValue(colors, forKeyPath: "colors")
        behavior.setValue(locations, forKeyPath: "locations")

        return behavior
    }

    public func getLightBehavior(
        color: CGColor,
        position: CGPoint,
        zPosition: CGFloat,
        falloff: NSNumber,
        spot: Bool,
        appliesAlpha: Bool,
        directionLatitude: NSNumber,
        coneAngle: NSNumber
    ) -> Any {
        let behavior = createBehavior(type: "light")
        behavior.setValue(color, forKeyPath: "color")
        behavior.setValue(position, forKeyPath: "position")
        behavior.setValue(falloff, forKeyPath: "falloff")
        behavior.setValue(zPosition, forKeyPath: "zPosition")
        behavior.setValue(spot, forKeyPath: "spot")
        behavior.setValue(appliesAlpha, forKeyPath: "appliesAlpha")
        behavior.setValue(directionLatitude, forKeyPath: "directionLatitude")
        behavior.setValue(coneAngle, forKeyPath: "coneAngle")

        return behavior
    }

    public func getDragBehavior(drag: CGFloat = 1) -> Any {
        let behavior = createBehavior(type: "drag")
        behavior.setValue("drag", forKey: "name")
        behavior.setValue(drag, forKey: "drag")

        return behavior
    }

    public func start(birthRate: Float = 1) {
        self.birthRate = birthRate
    }

    public func stop() {
        birthRate = 0
    }

    public func createBehavior(type: String) -> NSObject {
        guard let behaviorClass = NSClassFromString("CAEmitterBehavior") as? NSObject.Type else {
            return NSObject()
        }
        guard let behaviorWithType = behaviorClass.method(for: NSSelectorFromString("behaviorWithType:")) else {
            return NSObject()
        }
        let castedBehaviorWithType = unsafeBitCast(behaviorWithType, to: (@convention(c)(Any?, Selector, Any?) -> NSObject).self)
        return castedBehaviorWithType(behaviorClass, NSSelectorFromString("behaviorWithType:"), type)
    }
}
