//
//  ShimmersControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 23.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class ShimmersControllerNode: VASafeAreaDisplayNode {
    private lazy var acrossWindowShimmer0Node = _ShimmerExampleNode(data: .init())
        .flex(grow: 1)
    private lazy var acrossWindowShimmer1Node = _ShimmerExampleNode(data: .init())
        .flex(grow: 1)
    private lazy var acrossWindowShimmer2Node = _ShimmerExampleNode(data: .init())
        .flex(grow: 1)

    private lazy var notSynchronizedShimmer0Node = _ShimmerExampleNode(data: .init(isSynchronized: false))
        .flex(grow: 1)
    private lazy var notSynchronizedShimmer1Node = _ShimmerExampleNode(data: .init(isSynchronized: false))
        .flex(grow: 1)
    private lazy var notSynchronizedShimmer2Node = _ShimmerExampleNode(data: .init(isSynchronized: false))
        .flex(grow: 1)

    private lazy var notAcrossWindowShimmer0Node = _ShimmerExampleNode(data: .init(isAcrossWindow: false))
        .flex(grow: 1)
    private lazy var notAcrossWindowShimmer1Node = _ShimmerExampleNode(data: .init(isAcrossWindow: false))
        .flex(grow: 1)
    private lazy var notAcrossWindowShimmer2Node = _ShimmerExampleNode(data: .init(isAcrossWindow: false))
        .flex(grow: 1)

    override func didLoad() {
        super.didLoad()

        // To trigger shimmer update.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [self] in
            acrossWindowShimmer1Node.didEnterVisibleState()
            notSynchronizedShimmer1Node.didEnterVisibleState()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [self] in
            acrossWindowShimmer2Node.didEnterVisibleState()
            notSynchronizedShimmer2Node.didEnterVisibleState()
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(spacing: 64, cross: .stretch) {
                Row(spacing: 16) {
                    acrossWindowShimmer0Node
                    acrossWindowShimmer1Node
                    acrossWindowShimmer2Node
                }
                Row(spacing: 16) {
                    notSynchronizedShimmer0Node
                    notSynchronizedShimmer1Node
                    notSynchronizedShimmer2Node
                }
                Row(spacing: 16) {
                    notAcrossWindowShimmer0Node
                    notAcrossWindowShimmer1Node
                    notAcrossWindowShimmer2Node
                }
            }
            .padding(.all(16))
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
}

private class _ShimmerExampleNode: VAShimmerNode {
    private lazy var tileNode = VAShimmerTileNode(data: .init(cornerRadius: 8))
        .minConstrained(height: 50)

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        tileNode
            .wrapped()
    }
}
