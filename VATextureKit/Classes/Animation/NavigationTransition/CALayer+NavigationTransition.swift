//
//  CALayer+NavigationTransition.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 24.07.2023.
//

import UIKit

public struct VATransitionTimings {
    public let bounds: CAMediaTimingFunctionName
    public let positionX: CAMediaTimingFunctionName
    public let positionY: CAMediaTimingFunctionName
    public let cornerRadius: CAMediaTimingFunctionName
    public let opacity: CAMediaTimingFunctionName

    public init(
        bounds: CAMediaTimingFunctionName = .easeInEaseOut,
        positionX: CAMediaTimingFunctionName = .easeInEaseOut,
        positionY: CAMediaTimingFunctionName = .easeInEaseOut,
        cornerRadius: CAMediaTimingFunctionName = .easeInEaseOut,
        opacity: CAMediaTimingFunctionName = .easeInEaseOut
    ) {
        self.bounds = bounds
        self.positionX = positionX
        self.positionY = positionY
        self.cornerRadius = cornerRadius
        self.opacity = opacity
    }
}

public enum VATransitionAnimationAddition {
    case `default`
    case skip
    case skipSource
    case skipDestination
}

public struct VATransitionTimingsAddition {
    public let opacity: VATransitionAnimationAddition

    public init(opacity: VATransitionAnimationAddition = .default) {
        self.opacity = opacity
    }
}

public enum VATransitionAnimation {
    case `default`(timings: VATransitionTimings = .init(), additions: VATransitionTimingsAddition = .init())
}

public extension CALayer {
    nonisolated(unsafe) static let transitionAnimationTimingsKey = malloc(0)!
    nonisolated(unsafe) static let transitionAnimationIdKey = malloc(0)!

    var transitionAnimation: VATransitionAnimation {
        get { (objc_getAssociatedObject(self, Self.transitionAnimationTimingsKey) as? VATransitionAnimation) ?? .default() }
        set { objc_setAssociatedObject(self, Self.transitionAnimationTimingsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    var transitionAnimationId: String? {
        get { objc_getAssociatedObject(self, Self.transitionAnimationIdKey) as? String }
        set { objc_setAssociatedObject(self, Self.transitionAnimationIdKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

public extension CALayer {

    func getSnapshot(shouldUnhide: Bool = false) -> CALayer? {
        let wasHidden = isHidden
        if shouldUnhide && wasHidden {
            isHidden = false
        }
        let snapshot = getSubtreeSnapshot(layer: self)
        if shouldUnhide && wasHidden {
            isHidden = true
        }
        if let snapshot {
            snapshot.frame = frame
            snapshot.bounds = bounds
            
            return snapshot
        } else {
            return nil
        }
    }
}

private func getSubtreeSnapshot(layer: CALayer) -> CALayer? {
    if let layer = layer as? CAShapeLayer {
        let snapshot = CAShapeLayer()
        snapshot.backgroundColor = layer.backgroundColor
        snapshot.contents = layer.contents
        snapshot.contentsRect = layer.contentsRect
        snapshot.contentsScale = layer.contentsScale
        snapshot.contentsCenter = layer.contentsCenter
        snapshot.contentsGravity = layer.contentsGravity
        snapshot.cornerRadius = layer.cornerRadius
        snapshot.fillColor = layer.fillColor
        snapshot.fillRule = layer.fillRule
        snapshot.isHidden = layer.isHidden
        snapshot.lineCap = layer.lineCap
        snapshot.lineDashPattern = layer.lineDashPattern
        snapshot.lineDashPhase = layer.lineDashPhase
        snapshot.lineJoin = layer.lineJoin
        snapshot.lineWidth = layer.lineWidth
        snapshot.masksToBounds = layer.masksToBounds
        snapshot.miterLimit = layer.miterLimit
        snapshot.opacity = layer.opacity
        snapshot.path = layer.path
        snapshot.strokeColor = layer.strokeColor
        snapshot.strokeEnd = layer.strokeEnd
        snapshot.strokeStart = layer.strokeStart
        for sublayer in layer.sublayers ?? [] {
            if let subtree = getSubtreeSnapshot(layer: sublayer) {
                subtree.anchorPoint = sublayer.anchorPoint
                subtree.bounds = sublayer.bounds
                subtree.position = sublayer.position
                subtree.transform = sublayer.transform
                snapshot.addSublayer(subtree)
            } else {
                return nil
            }
        }
        
        return snapshot
    } else {
        let snapshot = CALayer()
        snapshot.backgroundColor = layer.backgroundColor
        snapshot.contents = layer.contents
        snapshot.contentsCenter = layer.contentsCenter
        snapshot.contentsGravity = layer.contentsGravity
        snapshot.contentsRect = layer.contentsRect
        snapshot.contentsScale = layer.contentsScale
        snapshot.cornerRadius = layer.cornerRadius
        snapshot.isHidden = layer.isHidden
        snapshot.masksToBounds = layer.masksToBounds
        snapshot.opacity = layer.opacity
        for sublayer in layer.sublayers ?? [] {
            if let subtree = getSubtreeSnapshot(layer: sublayer) {
                subtree.anchorPoint = sublayer.anchorPoint
                subtree.bounds = sublayer.bounds
                subtree.position = sublayer.position
                subtree.transform = sublayer.transform
                snapshot.addSublayer(subtree)
            } else {
                return nil
            }
        }

        return snapshot
    }
}
