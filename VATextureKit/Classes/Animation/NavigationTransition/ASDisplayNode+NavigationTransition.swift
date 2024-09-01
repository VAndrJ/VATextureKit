//
//  ASDisplayNode+NavigationTransition.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 24.07.2023.
//

public import AsyncDisplayKit

public extension ASDisplayNode {
    var transitionAnimationId: String? {
        get { layer.transitionAnimationId }
        set {
            ensureOnMain {
                layer.transitionAnimationId = newValue
            }
        }
    }
    var transitionAnimation: VATransitionAnimation {
        get { layer.transitionAnimation }
        set {
            ensureOnMain {
                layer.transitionAnimation = newValue
            }
        }
    }

    @discardableResult
    func withAnimatedTransition(id: String, animation: VATransitionAnimation? = nil) -> Self {
        transitionAnimationId = id
        if let animation {
            transitionAnimation = animation
        }
        
        return self
    }
}
