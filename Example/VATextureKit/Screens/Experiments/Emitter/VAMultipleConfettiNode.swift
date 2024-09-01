//
//  VAMultipleConfettiNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 02.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class VAMultipleConfettiNode: VADisplayNode, @unchecked Sendable {
    private lazy var topCenterConfettiNode = VAConfettiEmitterNode(context: .init(startPoint: .topCenter))
    private lazy var bottomLeftConfettiNode = VAConfettiEmitterNode(context: .init(startPoint: .bottomLeft))
    private lazy var bottomRightConfettiNode = VAConfettiEmitterNode(context: .init(startPoint: .bottomRight))

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Stack {
            topCenterConfettiNode
            bottomLeftConfettiNode
            bottomRightConfettiNode
        }
    }
}
