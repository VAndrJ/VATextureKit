//
//  ASDisplayNode+NavigationTransition.swift
//  Differentiator
//
//  Created by Volodymyr Andriienko on 24.07.2023.
//

import AsyncDisplayKit

public extension ASDisplayNode {
    var transitionAnimationId: String? {
        get { layer.transitionAnimationId }
        set {
            ensureOnMain { [self] in
                layer.transitionAnimationId = newValue
            }
        }
    }
    var transitionAnimation: VATransitionAnimation {
        get { layer.transitionAnimation }
        set {
            ensureOnMain { [self] in
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
