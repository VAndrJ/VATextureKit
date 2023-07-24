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

    @discardableResult
    func withAnimatedTransition(id: String) -> Self {
        transitionAnimationId = id
        return self
    }
}
