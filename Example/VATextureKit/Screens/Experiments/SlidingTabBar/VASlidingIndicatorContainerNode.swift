//
//  VASlidingIndicatorContainerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 03.05.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class VASlidingIndicatorContainerNode: VADisplayNode {
    var targetIndicatorFrame: CGRect = .zero {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    let indicatorNode = ASDisplayNode()

    private let color: (VATheme) -> UIColor

    init(color: @escaping (VATheme) -> UIColor) {
        self.color = color

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        indicatorNode
            .absolutely(frame: targetIndicatorFrame)
    }

    override func didLoad() {
        super.didLoad()

        configure()
    }

    override func configureTheme(_ theme: VATheme) {
        indicatorNode.backgroundColor = color(theme)
    }

    private func configure() {
        indicatorNode.cornerCurve = .continuous
    }
}
