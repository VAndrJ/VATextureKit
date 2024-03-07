//
//  EmitterLayerAnimationControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 01.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct EmitterLayerAnimationNavigationIdentity: DefaultNavigationIdentity {}

final class EmitterLayerAnimationControllerNode: VASafeAreaDisplayNode {
    private lazy var fireworksEmitterNode = VAFireworksEmitterNode(data: .init())
    private lazy var confettiTopCenterEmitterNode = VAConfettiEmitterNode(data: .init(startPoint: .topCenter))
    private lazy var confettiBottomLeftEmitterNode = VAConfettiEmitterNode(data: .init(startPoint: .bottomLeft))
    private lazy var confettiBottomRightEmitterNode = VAConfettiEmitterNode(data: .init(startPoint: .bottomRight))
    private lazy var confettiCenterEmitterNode = VAConfettiEmitterNode(data: .init(startPoint: .center))
    private lazy var multipleConfettiNode = VAMultipleConfettiNode()
    private lazy var textEmitterNode = VATextEmitterNode(data: .init())
    private lazy var rainEmitterNode = VARainEmitterNode(data: .init())
    private lazy var snowEmitterNode = VASnowEmitterNode(data: .init())
    private lazy var scrollNode = VAScrollNode(data: .init())
    private lazy var demoNodes = [
        textEmitterNode,
        fireworksEmitterNode,
        rainEmitterNode,
        snowEmitterNode,
        confettiTopCenterEmitterNode,
        confettiBottomLeftEmitterNode,
        confettiBottomRightEmitterNode,
        confettiCenterEmitterNode,
        multipleConfettiNode,
    ].ratio(1)

    init() {
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
            demoNodes
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
}
