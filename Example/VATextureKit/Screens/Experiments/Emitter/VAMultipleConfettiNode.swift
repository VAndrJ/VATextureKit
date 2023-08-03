//
//  VAMultipleConfettiNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 02.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class VAMultipleConfettiNode: VADisplayNode {
    private lazy var topCenterConfettiNode = VAConfettiEmitterNode(data: .init(startPoint: .topCenter))
    private lazy var bottomLeftConfettiNode = VAConfettiEmitterNode(data: .init(startPoint: .bottomLeft))
    private lazy var bottomRightConfettiNode = VAConfettiEmitterNode(data: .init(startPoint: .bottomRight))

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Stack {
            topCenterConfettiNode
            bottomLeftConfettiNode
            bottomRightConfettiNode
        }
    }
}
