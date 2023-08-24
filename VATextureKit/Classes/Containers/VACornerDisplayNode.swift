//
//  VACornerDisplayNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 24.08.2023.
//

import AsyncDisplayKit

open class VACornerDisplayNode: VADisplayNode, VACornerable {
    public var corner: VACornerRoundingParameters {
        didSet { updateCornerParameters() }
    }

    init(corner: VACornerRoundingParameters) {
        self.corner = corner

        super.init()
    }

    open override func didLoad() {
        super.didLoad()
        
        updateCornerParameters()
    }

    open override func layout() {
        super.layout()

        updateCornerProportionalIfNeeded()
    }
}
