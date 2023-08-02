//
//  EmitterLayerAnimationControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 01.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class EmitterLayerAnimationControllerNode: VASafeAreaDisplayNode {
    private lazy var emitterNode = VAFireworksNode()
    private lazy var scrollNode = VAScrollNode(data: .init())

    override init() {
        super.init()

        scrollNode.layoutSpecBlock = { [weak self] in
            self?.scrollLayoutSpecThatFits($1) ?? ASLayoutSpec()
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            scrollNode
        }
    }

    func scrollLayoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(cross: .stretch) {
            emitterNode
                .ratio(1)
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
}
